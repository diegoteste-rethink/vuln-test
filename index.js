const express = require('express');
const _ = require('lodash');
const mongoose = require('mongoose');

const app = express();
const port = 3000;

// Example route with potential security issues
app.get('/', (req, res) => {
  const userInput = req.query.userInput;

  // Using lodash without sanitizing user input - known vulnerability
  const compiled = _.template('Hello <%= userInput %>');
  res.send(compiled({ userInput: userInput }));

  // Example of a mongoose query - make sure to sanitize user input in real applications
  mongoose.connect('mongodb://localhost:27017/test', { useNewUrlParser: true, useUnifiedTopology: true });
  const Cat = mongoose.model('Cat', { name: String });
  const kitty = new Cat({ name: userInput });
  kitty.save().then(() => console.log('meow'));
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
