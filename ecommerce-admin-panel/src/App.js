import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, NavLink } from 'react-router-dom';
import AddProduct from './components/AddProduct';
import OrderManage from './components/OrderManage';
import './App.css'; // Tailwind CSS import

function App() {
  return (
    <Router>
      <div className="flex h-screen bg-gray-200 text-gray-800">
        {/* Side Navigation */}
        <div className="w-64 bg-white p-5 shadow-md">
          <h1 className="text-xl font-bold mb-10 text-black border-b pb-3">Admin Panel</h1>
          <ul>
            <li className="mb-6">
              <NavLink to="/add-product" className={({ isActive }) => isActive ? "bg-gray-700 text-white p-2 rounded block" : "bg-gray-300 hover:bg-gray-400 text-gray-800 p-2 rounded block transition duration-200 ease-in-out"}>
                Add Product
              </NavLink>
            </li>
            <li>
              <NavLink to="/manage-orders" className={({ isActive }) => isActive ? "bg-gray-700 text-white p-2 rounded block" : "bg-gray-300 hover:bg-gray-400 text-gray-800 p-2 rounded block transition duration-200 ease-in-out"}>
                Manage Orders
              </NavLink>
            </li>
          </ul>
        </div>
        {/* Main Content Area */}
        <div className="flex-grow p-5 bg-white m-5 shadow-lg rounded-lg">
          <Routes>
            <Route path="/add-product" element={<AddProduct />} />
            <Route path="/manage-orders" element={<OrderManage />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;
