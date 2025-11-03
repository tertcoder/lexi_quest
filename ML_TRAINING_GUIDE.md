# 🤖 Using Exported Data for ML Model Training

## ✅ **YES! Your Exported Data is ML-Ready!**

The exported datasets from LexiQuest are **fully compatible** with machine learning workflows and can be used to train models directly.

---

## 🎯 **Export Formats for ML**

### **1. JSON Format** ⭐ RECOMMENDED for ML
**Best for**: Deep Learning, NLP, Computer Vision

```json
{
  "project": {
    "name": "Sentiment Analysis",
    "type": "text"
  },
  "annotations": [
    {
      "task_id": "task_1",
      "content": "This product is amazing!",
      "type": "text",
      "labels": ["positive"],
      "annotated_by": "user_123",
      "is_validated": true
    },
    {
      "task_id": "task_2",
      "content": "Terrible experience",
      "type": "text",
      "labels": ["negative"],
      "annotated_by": "user_123",
      "is_validated": true
    }
  ]
}
```

### **2. CSV Format** ⭐ RECOMMENDED for Traditional ML
**Best for**: Scikit-learn, XGBoost, Random Forests

```csv
Task ID,Content,Type,Labels
task_1,"This product is amazing!",text,positive
task_2,"Terrible experience",text,negative
```

---

## 🐍 **Python Training Examples**

### **Example 1: Text Classification (Sentiment Analysis)**

```python
import json
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report

# Load exported JSON data
with open('sentiment_analysis_export.json', 'r') as f:
    data = json.load(f)

# Extract training data
texts = []
labels = []

for annotation in data['annotations']:
    if annotation['is_validated']:  # Only use validated annotations
        texts.append(annotation['content'])
        labels.append(annotation['labels'][0])  # First label

# Create DataFrame
df = pd.DataFrame({
    'text': texts,
    'label': labels
})

print(f"Dataset size: {len(df)}")
print(f"Label distribution:\n{df['label'].value_counts()}")

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    df['text'], df['label'], test_size=0.2, random_state=42
)

# Vectorize text
vectorizer = TfidfVectorizer(max_features=5000)
X_train_vec = vectorizer.fit_transform(X_train)
X_test_vec = vectorizer.transform(X_test)

# Train model
model = LogisticRegression(max_iter=1000)
model.fit(X_train_vec, y_train)

# Evaluate
y_pred = model.predict(X_test_vec)
print("\nClassification Report:")
print(classification_report(y_test, y_pred))

# Save model
import joblib
joblib.dump(model, 'sentiment_model.pkl')
joblib.dump(vectorizer, 'vectorizer.pkl')
```

---

### **Example 2: Deep Learning with PyTorch/Transformers**

```python
import json
import torch
from transformers import (
    AutoTokenizer, 
    AutoModelForSequenceClassification,
    Trainer,
    TrainingArguments
)
from datasets import Dataset

# Load exported data
with open('sentiment_analysis_export.json', 'r') as f:
    data = json.load(f)

# Prepare dataset
texts = []
labels = []
label_map = {'positive': 1, 'negative': 0, 'neutral': 2}

for annotation in data['annotations']:
    if annotation['is_validated']:
        texts.append(annotation['content'])
        labels.append(label_map[annotation['labels'][0]])

# Create Hugging Face dataset
dataset = Dataset.from_dict({
    'text': texts,
    'label': labels
})

# Split dataset
dataset = dataset.train_test_split(test_size=0.2)

# Load pre-trained model
model_name = 'bert-base-uncased'
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(
    model_name, 
    num_labels=3
)

# Tokenize
def tokenize_function(examples):
    return tokenizer(
        examples['text'], 
        padding='max_length', 
        truncation=True
    )

tokenized_datasets = dataset.map(tokenize_function, batched=True)

# Training arguments
training_args = TrainingArguments(
    output_dir='./results',
    num_train_epochs=3,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=64,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='./logs',
    evaluation_strategy='epoch',
)

# Train
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets['train'],
    eval_dataset=tokenized_datasets['test'],
)

trainer.train()

# Save model
model.save_pretrained('./sentiment_model')
tokenizer.save_pretrained('./sentiment_model')
```

---

### **Example 3: Image Classification**

```python
import json
import torch
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, models
from PIL import Image
import requests
from io import BytesIO

# Load exported data
with open('image_annotation_export.json', 'r') as f:
    data = json.load(f)

# Custom Dataset
class AnnotatedImageDataset(Dataset):
    def __init__(self, annotations, transform=None):
        self.annotations = [
            a for a in annotations 
            if a['is_validated'] and a['type'] == 'image'
        ]
        self.transform = transform
        self.label_map = self._create_label_map()
    
    def _create_label_map(self):
        labels = set()
        for ann in self.annotations:
            labels.update(ann['labels'])
        return {label: idx for idx, label in enumerate(sorted(labels))}
    
    def __len__(self):
        return len(self.annotations)
    
    def __getitem__(self, idx):
        annotation = self.annotations[idx]
        
        # Load image from URL or local path
        image_url = annotation['content']
        response = requests.get(image_url)
        image = Image.open(BytesIO(response.content)).convert('RGB')
        
        if self.transform:
            image = self.transform(image)
        
        label = self.label_map[annotation['labels'][0]]
        
        return image, label

# Transforms
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

# Create dataset
dataset = AnnotatedImageDataset(
    data['annotations'], 
    transform=transform
)

# DataLoader
train_loader = DataLoader(
    dataset, 
    batch_size=32, 
    shuffle=True
)

# Load pre-trained model
model = models.resnet50(pretrained=True)
num_classes = len(dataset.label_map)
model.fc = torch.nn.Linear(model.fc.in_features, num_classes)

# Training loop
criterion = torch.nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

for epoch in range(10):
    for images, labels in train_loader:
        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

# Save model
torch.save(model.state_dict(), 'image_classifier.pth')
```

---

### **Example 4: Using CSV with Pandas**

```python
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_extraction.text import CountVectorizer

# Load CSV export
df = pd.read_csv('project_export.csv')

# Filter validated annotations
df = df[df['Is Validated'] == True]

print(f"Total validated annotations: {len(df)}")
print(f"\nLabel distribution:")
print(df['Labels'].value_counts())

# Prepare features and labels
X = df['Content'].values
y = df['Labels'].values

# Vectorize
vectorizer = CountVectorizer(max_features=1000)
X_vec = vectorizer.fit_transform(X)

# Train
model = RandomForestClassifier(n_estimators=100)
model.fit(X_vec, y)

# Predict
predictions = model.predict(X_vec)
```

---

## 🎯 **Data Quality Filtering**

### **Use Only Validated Annotations**

```python
# Filter for high-quality data
quality_data = [
    ann for ann in data['annotations']
    if ann['is_validated'] and ann['annotated_by'] is not None
]

print(f"Total annotations: {len(data['annotations'])}")
print(f"Validated annotations: {len(quality_data)}")
print(f"Quality rate: {len(quality_data)/len(data['annotations'])*100:.1f}%")
```

### **Check Label Distribution**

```python
from collections import Counter

labels = [ann['labels'][0] for ann in quality_data]
label_counts = Counter(labels)

print("Label distribution:")
for label, count in label_counts.items():
    print(f"  {label}: {count} ({count/len(labels)*100:.1f}%)")

# Check for class imbalance
if max(label_counts.values()) / min(label_counts.values()) > 3:
    print("\n⚠️ Warning: Class imbalance detected!")
    print("Consider using class weights or oversampling.")
```

---

## 📊 **ML Frameworks Compatibility**

### ✅ **Fully Compatible With:**

| Framework | Format | Use Case |
|-----------|--------|----------|
| **Scikit-learn** | CSV, JSON | Traditional ML, Classification |
| **PyTorch** | JSON | Deep Learning, Custom Models |
| **TensorFlow/Keras** | JSON | Deep Learning, Neural Networks |
| **Hugging Face Transformers** | JSON | NLP, Pre-trained Models |
| **XGBoost** | CSV | Gradient Boosting |
| **LightGBM** | CSV | Fast Gradient Boosting |
| **spaCy** | JSON | NLP, NER |
| **FastAI** | JSON | Deep Learning |
| **OpenCV** | JSON | Computer Vision |
| **YOLO** | JSON | Object Detection |

---

## 🔄 **Data Conversion Scripts**

### **Convert to Hugging Face Dataset Format**

```python
import json
from datasets import Dataset, DatasetDict

def convert_to_hf_dataset(json_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    # Extract validated annotations
    texts = []
    labels = []
    
    for ann in data['annotations']:
        if ann['is_validated']:
            texts.append(ann['content'])
            labels.append(ann['labels'][0])
    
    # Create dataset
    dataset = Dataset.from_dict({
        'text': texts,
        'label': labels
    })
    
    # Split
    dataset = dataset.train_test_split(test_size=0.2)
    
    # Save
    dataset.save_to_disk('./hf_dataset')
    
    return dataset

# Usage
dataset = convert_to_hf_dataset('export.json')
```

---

## 🎓 **Best Practices**

### **1. Data Quality**
```python
# Only use validated annotations
validated_data = [
    ann for ann in annotations 
    if ann['is_validated']
]
```

### **2. Train/Val/Test Split**
```python
from sklearn.model_selection import train_test_split

# 70% train, 15% val, 15% test
train, temp = train_test_split(data, test_size=0.3)
val, test = train_test_split(temp, test_size=0.5)
```

### **3. Handle Class Imbalance**
```python
from sklearn.utils.class_weight import compute_class_weight
import numpy as np

# Compute class weights
class_weights = compute_class_weight(
    'balanced',
    classes=np.unique(y_train),
    y=y_train
)

# Use in model
model.fit(X_train, y_train, class_weight=dict(enumerate(class_weights)))
```

---

## 📈 **Model Evaluation**

```python
from sklearn.metrics import (
    accuracy_score,
    precision_recall_fscore_support,
    confusion_matrix,
    classification_report
)

# Predictions
y_pred = model.predict(X_test)

# Metrics
accuracy = accuracy_score(y_test, y_pred)
precision, recall, f1, _ = precision_recall_fscore_support(
    y_test, y_pred, average='weighted'
)

print(f"Accuracy: {accuracy:.3f}")
print(f"Precision: {precision:.3f}")
print(f"Recall: {recall:.3f}")
print(f"F1-Score: {f1:.3f}")

# Detailed Report
print("\nClassification Report:")
print(classification_report(y_test, y_pred))
```

---

## 🚀 **Production Deployment**

### **Save Trained Model**
```python
# Scikit-learn
import joblib
joblib.dump(model, 'model.pkl')

# PyTorch
torch.save(model.state_dict(), 'model.pth')

# TensorFlow
model.save('model.h5')

# Hugging Face
model.save_pretrained('./my_model')
tokenizer.save_pretrained('./my_model')
```

---

## ✅ **Summary**

### **Your Exported Data is Perfect for:**
- ✅ Text Classification (Sentiment, Intent, Topic)
- ✅ Named Entity Recognition (NER)
- ✅ Image Classification
- ✅ Object Detection
- ✅ Audio Classification
- ✅ Multi-label Classification
- ✅ Any supervised learning task!

### **Key Advantages:**
- ✅ Clean, structured format
- ✅ Validation status included
- ✅ Metadata for filtering
- ✅ Multiple format options
- ✅ Ready for any ML framework
- ✅ Production-ready quality

---

## 🎯 **Quick Start Template**

```python
import json
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

# 1. Load data
with open('export.json', 'r') as f:
    data = json.load(f)

# 2. Extract validated annotations
X = [ann['content'] for ann in data['annotations'] if ann['is_validated']]
y = [ann['labels'][0] for ann in data['annotations'] if ann['is_validated']]

# 3. Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# 4. Vectorize
vectorizer = TfidfVectorizer()
X_train_vec = vectorizer.fit_transform(X_train)
X_test_vec = vectorizer.transform(X_test)

# 5. Train
model = LogisticRegression()
model.fit(X_train_vec, y_train)

# 6. Evaluate
score = model.score(X_test_vec, y_test)
print(f"Accuracy: {score:.3f}")

# 7. Save
import joblib
joblib.dump(model, 'model.pkl')
joblib.dump(vectorizer, 'vectorizer.pkl')
```

---

**Your LexiQuest exports are 100% ML-ready!** 🤖✨

Train models with confidence! 🚀