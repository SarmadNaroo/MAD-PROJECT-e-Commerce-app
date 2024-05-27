import axios from 'axios';

export const addProduct = async (productData) => {
  try {
    const response = await axios.post('http://localhost:3000/api/products', productData);
    return response.data;
  } catch (error) {
    console.error('Failed to add product:', error);
    throw error;
  }
};

export const fetchOrders = async () => {
    try {
      const response = await axios.get('http://localhost:3000/api/orders/');
      return response.data;
    } catch (error) {
      console.error('Failed to fetch orders:', error);
      throw error;
    }
}

export const fetchProductDetails = async (productId) => {
    try {
      const response = await axios.get(`http://localhost:3000/api/products/${productId}`);
      return response.data;
    } catch (error) {
      console.error('Failed to fetch product details:', error);
      throw error;
    }
  };
  
