import { useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../api/api";

export default function AdminLoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const login = async () => {
    try {
      const res = await api.post("/admin/login", { email, password });

      localStorage.setItem("adminToken", res.data.token);

      alert("Đăng nhập Admin thành công!");

      navigate("/");
    } catch (err) {
      console.log(err);
      alert(err.response?.data?.message || "Sai tài khoản hoặc mật khẩu");
    }
  };

  return (
    <div className="login-page">
      <h2>ADMIN LOGIN</h2>

      <input
        type="email"
        placeholder="Email..."
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <input
        type="password"
        placeholder="Mật khẩu..."
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />

      <button onClick={login}>Đăng nhập</button>
    </div>
  );
}
