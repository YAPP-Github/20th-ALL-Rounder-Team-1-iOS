[![](https://i.imgur.com/yArwEjd.png)](https://apple.co/3BHGgec)

#  🐳 Weekand 🐳 

Weekand는 일정을 관리하고 친구들 또는 다른사람들에게 공유하고 서로의 일정을 참고하고 응원하면서 더 좋은 습관과 생활을 형성하는 것을 도와주는 서비스입니다

🐋 나의 일정을 손쉽게 관리해요

🐋 일정을 참고하고 싶은 유저를 팔로우하고 일정을 구독할 수 있어요

🐋 친구룰 팔로우하고 서로의 일정에 대해 스티커로 반응해요

## WorkFlow
![](https://i.imgur.com/tUK8JRn.jpg)


## Developers
🧑‍💻 [최대건](https://github.com/ChoiysApple)

🐹 [이호영](https://github.com/llghdud921)
 

## Architecture
Clean Architecture + MVVM-C 

## Tech Stack
- iOS 14.0+
- UIKit
- RxSwift

## Library
- `Apollo`
- `RxSwift` `RxCocoa` `RxRelay`
- `Snapkit`
- `FSCalendar` `DropDown` `Tabman` `AlignedCollectionViewFlowLayout`

## issue Convention
```
[Type] SceneName - issue Name
```
***i.e.***`[Fix] ProfileScene - 남의 프로필에서 직업/관심사 부분이 나타나지 않는다`
- **[Fix]** *수정이 필요한 이슈*
- **[Feat]** *새로운 기능 구현*
- **[Refactor]** *리팩토링*

## File Structure
Based on [iOS Clean Architecture MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
Presentaion 내부 구조를 MVVM-Coordinator에 사용하기 쉽도록 재구성
```
Weekand
├── Networking
├── Application
├── Base
├── Presentation
    └── Scene
        ├── Common
        └──  View
            ├── Coordinator
            ├── ViewModel
            └── View
├── Data
├── Domain
└── Resources
```

## 회고

✍️ 대건

✍️ 호영
