import { useState, useEffect } from 'react'
import axios from 'axios'

const API_BASE_URL = 'http://localhost:5000/api'

function TodoList({ onLogout }) {
  const [todos, setTodos] = useState([])
  const [newTodo, setNewTodo] = useState('')
  const [editingId, setEditingId] = useState(null)
  const [editingTitle, setEditingTitle] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [user, setUser] = useState(null)

  useEffect(() => {
    // Récupérer les infos utilisateur
    const userData = localStorage.getItem('user')
    if (userData) {
      setUser(JSON.parse(userData))
    }
    
    fetchTodos()
  }, [])

  const getAuthHeaders = () => {
    const token = localStorage.getItem('token')
    return {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    }
  }

  const fetchTodos = async () => {
    try {
      setLoading(true)
      const response = await axios.get(`${API_BASE_URL}/todos`, getAuthHeaders())
      setTodos(response.data)
      setError('')
    } catch (err) {
      if (err.response?.status === 401 || err.response?.status === 403) {
        onLogout() // Token invalide, déconnecter
      } else {
        setError('Failed to fetch todos')
      }
    } finally {
      setLoading(false)
    }
  }

  const addTodo = async (e) => {
    e.preventDefault()
    if (!newTodo.trim()) return

    try {
      const response = await axios.post(
        `${API_BASE_URL}/todos`,
        { title: newTodo.trim() },
        getAuthHeaders()
      )
      setTodos([...todos, response.data])
      setNewTodo('')
      setError('')
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to add todo')
    }
  }

  const updateTodo = async (id, updates) => {
    try {
      const response = await axios.put(
        `${API_BASE_URL}/todos/${id}`,
        updates,
        getAuthHeaders()
      )
      setTodos(todos.map(todo => 
        todo.id === id ? response.data : todo
      ))
      setError('')
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to update todo')
    }
  }

  const deleteTodo = async (id) => {
    if (!window.confirm('Are you sure you want to delete this todo?')) return

    try {
      await axios.delete(`${API_BASE_URL}/todos/${id}`, getAuthHeaders())
      setTodos(todos.filter(todo => todo.id !== id))
      setError('')
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to delete todo')
    }
  }

  const toggleComplete = async (todo) => {
    await updateTodo(todo.id, { completed: !todo.completed })
  }

  const startEditing = (todo) => {
    setEditingId(todo.id)
    setEditingTitle(todo.title)
  }

  const saveEdit = async () => {
    if (!editingTitle.trim()) return

    await updateTodo(editingId, { title: editingTitle.trim() })
    setEditingId(null)
    setEditingTitle('')
  }

  const cancelEdit = () => {
    setEditingId(null)
    setEditingTitle('')
  }

  if (loading) {
    return <div className="loading" data-testid="loading">Loading todos...</div>
  }

  return (
    <div className="todo-container">
      <header className="todo-header">
        <h1>My Todos</h1>
        <div className="user-info">
          <span>Welcome, {user?.username}</span>
          <button 
            onClick={onLogout} 
            className="logout-button"
            data-testid="logout-button"
          >
            Logout
          </button>
        </div>
      </header>

      {error && (
        <div className="error-message" data-testid="error-message">
          {error}
        </div>
      )}

      <form onSubmit={addTodo} className="add-todo-form" data-testid="add-todo-form">
        <input
          type="text"
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Add a new todo..."
          data-testid="new-todo-input"
          className="add-todo-input"
        />
        <button 
          type="submit"
          data-testid="add-todo-button"
          className="add-todo-button"
        >
          Add Todo
        </button>
      </form>

      <div className="todos-list" data-testid="todos-list">
        {todos.length === 0 ? (
          <p className="no-todos" data-testid="no-todos">No todos yet. Add one above!</p>
        ) : (
          todos.map(todo => (
            <div 
              key={todo.id} 
              className={`todo-item ${todo.completed ? 'completed' : ''}`}
              data-testid="todo-item"
            >
              <div className="todo-content">
                <input
                  type="checkbox"
                  checked={todo.completed}
                  onChange={() => toggleComplete(todo)}
                  data-testid={`todo-checkbox-${todo.id}`}
                />
                
                {editingId === todo.id ? (
                  <input
                    type="text"
                    value={editingTitle}
                    onChange={(e) => setEditingTitle(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') saveEdit()
                      if (e.key === 'Escape') cancelEdit()
                    }}
                    data-testid={`edit-todo-input-${todo.id}`}
                    className="edit-todo-input"
                    autoFocus
                  />
                ) : (
                  <span 
                    className="todo-title"
                    data-testid={`todo-title-${todo.id}`}
                  >
                    {todo.title}
                  </span>
                )}
              </div>
              
              <div className="todo-actions">
                {editingId === todo.id ? (
                  <>
                    <button
                      onClick={saveEdit}
                      data-testid={`save-todo-${todo.id}`}
                      className="save-button"
                    >
                      Save
                    </button>
                    <button
                      onClick={cancelEdit}
                      data-testid={`cancel-edit-${todo.id}`}
                      className="cancel-button"
                    >
                      Cancel
                    </button>
                  </>
                ) : (
                  <>
                    <button
                      onClick={() => startEditing(todo)}
                      data-testid={`edit-todo-${todo.id}`}
                      className="edit-button"
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => deleteTodo(todo.id)}
                      data-testid={`delete-todo-${todo.id}`}
                      className="delete-button"
                    >
                      Delete
                    </button>
                  </>
                )}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  )
}

export default TodoList