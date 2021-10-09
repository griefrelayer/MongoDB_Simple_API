from mongodb_simple_api import app
from unittest import TestCase


class TestAPI(TestCase):
    def setUp(self) -> None:
        self.app = app.test_client()
        self.test_data_id = ''

    def test_post_data(self):
        response = self.app.post('/post_data', json={'data': {'some_test_key': 'some_test_value'}})
        self.test_data_id = response.get_data(as_text=True)[1:-2]
        self.assertEqual(response.status_code, 200)

    def test_get_data(self):
        if not self.test_data_id:
            self.test_post_data()
        response = self.app.get('/get_data/' + self.test_data_id)
        self.assertIn('some_test_value', response.get_data(as_text=True))

