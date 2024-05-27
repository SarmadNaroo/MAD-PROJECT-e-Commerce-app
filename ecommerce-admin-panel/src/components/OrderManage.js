import React, { useState, useEffect } from 'react';
import { fetchOrders, fetchProductDetails } from '../api/services';

function OrderManage() {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    const loadOrders = async () => {
      try {
        const fetchedOrders = await fetchOrders();
        for (const order of fetchedOrders) {
          const products = [];

          if (Array.isArray(order.productIds)) {
            for (const productId of order.productIds) {
              try {
                const product = await fetchProductDetails(productId);
                products.push(product);
              } catch (error) {
                console.error(`Failed to fetch product details for product ID ${productId}:`, error);
              }
            }
          }

          // Attach products to the order
          order.products = products;
        }
        setOrders(fetchedOrders);
      } catch (error) {
        console.error('Error fetching orders:', error);
      }
    };

    loadOrders();
  }, []);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 overflow-y-auto h-screen">
      <h1 className="text-2xl font-bold text-gray-800 my-6">Orders List</h1>
      <div className="bg-white shadow overflow-hidden sm:rounded-lg">
        <ul className="divide-y divide-gray-200">
          {orders.map(order => (
            <li key={order._id} className="px-4 py-4 sm:px-6">
              <div className="flex flex-col sm:flex-row justify-between space-y-4 sm:space-y-0">
                <div className="flex-1">
                  <h3 className="text-lg leading-6 font-medium text-gray-900">Order ID: {order.id}</h3>
                  <p className="mt-1 max-w-2xl text-sm text-gray-500">Customer Name: {order.name}</p>
                  <p className="text-sm text-gray-500">Phone: {order.phone}</p>
                  <p className="text-sm text-gray-500">City: {order.city}</p>
                  <p className="text-sm text-gray-500">Postal Address: {order.postalAddress}</p>
                  <p className="text-sm text-gray-500">Order Placed: {new Date(order.orderPlaced).toLocaleDateString()}</p>
                  <p className="text-sm text-gray-500">Processed: {order.orderProcessedStatus ? 'Yes' : 'No'}</p>
                  <p className="text-sm text-gray-500">Shipped: {order.orderShippedStatus ? 'Yes' : 'No'}</p>
                  <p className="text-sm text-gray-500">Out for Delivery: {order.outForDeliveryStatus ? 'Yes' : 'No'}</p>
                  <p className="text-sm text-gray-500">Delivered: {order.deliveredStatus ? 'Yes' : 'No'}</p>
                </div>
                <div className="flex flex-wrap">
                  {order.products.map(product => (
                    <div key={product._id} className="m-2">
                      <img className="h-20 w-20 rounded-full" src={product.image} alt={product.title} />
                      <p className="text-sm text-gray-700">{product.title}</p>
                    </div>
                  ))}
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default OrderManage;
