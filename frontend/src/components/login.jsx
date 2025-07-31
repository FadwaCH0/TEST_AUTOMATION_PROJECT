import { useState } from 'react'
import axios from 'axios'

const API_BASE_URL = 'http://localhost:5000/api'

function Login({ onLogin }) {
  const [formData, setFormData] = useState({
    username: '',
    password: ''
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
    setError('') // Clear error when user types
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    try {
      const response = await axios.post(`${API_BASE_URL}/auth/login`, formData)
      onLogin(response.data.token, response.data.user)
    } catch (err) {
      setError(
        err.response?.data?.error || 
        err.response?.data?.errors?.[0]?.msg || 
        'Login failed'
      )
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-container">
      <div className="login-form">
        <h2>Todo App Login</h2>
        <p className="login-info">
          <strong>Test credentials:</strong><br />
          Username: testuser<br />
          Password: password
        </p>
        
        <form onSubmit={handleSubmit} data-testid="login-form">
          <div className="form-group">
            <label htmlFor="username">Username:</label>
            <input
              type="text"
              id="username"
              name="username"
              value={formData.username}
              onChange={handleChange}
              data-testid="username-input"
              required
            />
          </div>
          
          <div className="form-group">
            <label htmlFor="password">Passwor:</label>
            <input
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              data-testid="password-input"
              required
            />
          </div>
          
          {error && (
            <div className="error-message" data-testid="error-message">
              {error}
            </div>
          )}
          
          <button 
            type="submit" 
            disabled={loading}
            data-testid="login-button"
            className="login-button"
          >
            {loading ? 'Logging in...' : 'Login'}
          </button>
        </form>
      </div>
    </div>
  )
}

export default Login