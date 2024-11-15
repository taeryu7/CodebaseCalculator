# CodebaseCalculator

# iOS Calculator App Guide

간단한 계산기 앱을 구현하는 단계별 가이드

## 주요 기능 구현 가이드

### Level 1: 수식 표시 레이블 구현
`UILabel`을 사용하여 계산기의 수식을 표시하는 레이블을 구현

#### Label 속성
- 배경색: Black
- 텍스트 색상: White
- 초기 텍스트: "12345"
- 텍스트 정렬: 오른쪽
- 폰트: System Bold, 크기 60

#### AutoLayout 설정
- Leading, Trailing: SuperView로부터 30포인트
- Top: SuperView로부터 200포인트
- Height: 100포인트

### Level 2: 가로 스택뷰 구현
`UIStackView`를 사용하여 4개의 버튼을 포함하는 가로 스택뷰를 생성

#### 버튼 속성
```swift
// UIButton 속성
- font = .boldSystemFont(ofSize: 30)
- backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
- frame.size.height = 80
- frame.size.width = 80
- layer.cornerRadius = 40
```

#### 가로 스택뷰 속성
```swift
// UIStackView 속성
- axis = .horizontal
- backgroundColor = .black
- spacing = 10
- distribution = .fillEqually
```

#### AutoLayout 설정
- Height: 80포인트


### Level 3: 세로 스택뷰 구현
여러 개의 가로 스택뷰를 포함하는 세로 스택뷰를 생성

#### 세로 스택뷰 속성
```swift
// verticalStackView 속성
- axis = .vertical
- backgroundColor = .black
- spacing = 10
- distribution = .fillEqually
```

#### AutoLayout 설정
- Width: 350포인트
- Top: Label의 bottom으로부터 60포인트
- CenterX: SuperView의 centerX와 동일

### Level 4: 연산 버튼 스타일링
연산 버튼들(+, -, *, /, AC, =)의 스타일을 설정


### Level 5: 원형 버튼 구현
모든 버튼을 원형으로 만들기.

#### 구현 세부사항
- HorizontalStackView 높이: 80포인트
- VerticalStackView 너비: 350포인트
- VerticalStackView spacing: 10포인트
- 버튼 크기 계산: (350 - 10 * 3) / 4 = 80포인트
- 모든 버튼은 80x80 정사각형
- cornerRadius = 40 (버튼 너비의 절반)으로 설정하여 원형으로 만듦

## 다음 단계
기본적인 UI 구현이 완료되면, 계산기의 실제 기능을 구현하는 로직 개발을 진행

### Level 6: 버튼 입력 처리
버튼 클릭 시 라벨에 수식이 표시되도록 구현합

#### 구현 요구사항
1. **초기값 설정**
   - 기본 텍스트를 "12345"에서 "0"으로 변경

2. **버튼 입력 처리**
   - 버튼 클릭 시 현재 표시된 텍스트 오른쪽에 새로운 값 추가
   
   예시 시나리오:
   ```
   1. 초기 상태: "0"
   2. 1 클릭 → "01"
   3. 2 클릭 → "02"
   4. + 클릭 → "02+"
   5. 3 클릭 → "02+3"
   ```

3. **선행 제로(0) 처리**
   - 숫자 앞에 불필요한 0이 있는 경우 제거
   - 예: "012" → "12"로 자동 변환


### Level 7: 초기화(AC) 기능 구현
AC(All Clear) 버튼 기능을 구현

#### 구현 요구사항
- AC 버튼 클릭 시
  - 모든 입력값 초기화
  - 디스플레이를 "0"으로 리셋


## 구현 체크리스트
### Level 6
-  초기 디스플레이 값을 "0"으로 설정
-  버튼 클릭 시 디스플레이에 값 추가 구현
-  선행 제로 자동 제거 기능 구현

### Level 7
-  AC 버튼 클릭 시 초기화 기능 구현

## 다음 단계
기본적인 숫자 입력과 초기화 기능이 구현되면, 실제 계산 로직을 구현하는 단계로 진행

### Level 8
-  등호 (=) 버튼을 클릭하면 연산이 수행되도록 구현

## 📱 최종 결과물
- 숫자 입력 처리
- 연산자 입력 처리
- 초기화 기능
- 자동 선행 제로 제거

### Level 9 자체적으로 수행한 개선점
- 1. 수식기호 2번이상 터치시 에러 출력
- 2. 연산버튼 터치 후 자동으로 새로 입력하는것으로 초기화 기능 구현
- 3. 9자리 넘어갈 시 ... 으로 출력되던거 라벨내 text사이즈 줄이는 기능 구현
- 4. 주석 세분화 및 readme.md 파일 수정

#### 개선사항
- 1. 코드 간략화 작업
- 2. 모듈화를 통한 기능별 파일 분류
