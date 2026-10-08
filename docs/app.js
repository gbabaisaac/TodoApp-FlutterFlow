const seedTasks = [
  { title: 'Turn in CSC 305 Assignment 3', done: true },
  { title: 'Study for the Week 3 reflection', done: true },
  { title: 'Review Scrum user stories', done: false },
  { title: 'Test the inspirational quote feature', done: false }
];

let tasks = JSON.parse(localStorage.getItem('isaacs-tasks') || 'null') || seedTasks;
let filter = 'all';
const list = document.querySelector('#taskList');
const input = document.querySelector('#taskInput');

function saveAndRender() {
  localStorage.setItem('isaacs-tasks', JSON.stringify(tasks));
  render();
}

function render() {
  const visible = tasks.filter(task => filter === 'all' || (filter === 'done' ? task.done : !task.done));
  list.innerHTML = '';
  visible.forEach(task => {
    const row = document.createElement('li');
    row.className = `task${task.done ? ' done' : ''}`;
    row.innerHTML = `<input class="check" type="checkbox" ${task.done ? 'checked' : ''}><span class="title"></span><button class="delete" aria-label="Delete task">Delete</button>`;
    row.querySelector('.title').textContent = task.title;
    row.querySelector('.check').addEventListener('change', event => { task.done = event.target.checked; saveAndRender(); });
    row.querySelector('.delete').addEventListener('click', () => { tasks = tasks.filter(item => item !== task); saveAndRender(); });
    list.append(row);
  });
  document.querySelector('#remaining').textContent = tasks.filter(task => !task.done).length;
  document.querySelector('#completed').textContent = tasks.filter(task => task.done).length;
}

function addTask() {
  const title = input.value.trim();
  if (!title) return;
  tasks.unshift({ title, done: false });
  input.value = '';
  saveAndRender();
}

async function loadQuote() {
  const text = document.querySelector('#quoteText');
  const author = document.querySelector('#quoteAuthor');
  text.textContent = 'Finding a thought for your day…';
  author.textContent = 'Zen Quotes';
  try {
    const response = await fetch('https://zenquotes.io/api/random');
    if (!response.ok) throw new Error('Request failed');
    const [quote] = await response.json();
    text.textContent = quote.q;
    author.textContent = `— ${quote.a}`;
  } catch {
    text.textContent = 'The secret of getting ahead is getting started.';
    author.textContent = '— Mark Twain · offline fallback';
  }
}

document.querySelector('#addButton').addEventListener('click', addTask);
input.addEventListener('keydown', event => { if (event.key === 'Enter') addTask(); });
document.querySelectorAll('[data-filter]').forEach(button => button.addEventListener('click', () => {
  filter = button.dataset.filter;
  document.querySelectorAll('[data-filter]').forEach(item => item.classList.toggle('active', item === button));
  render();
}));
document.querySelector('#refreshQuote').addEventListener('click', loadQuote);

render();
loadQuote();
