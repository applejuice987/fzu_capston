https://drive.google.com/file/d/1XhwO-Fq7k-mumZkcEWgtqEDMUjXmV98K/view?usp=sharing

위 링크를 통해서 내가 만들었던 pdf를 확인할 수 있음.

그냥 다운받아

그외 필요한 자료
Column, Row 관련
https://m.blog.naver.com/cowbori/222081713773

캡스톤 시작
asdfasdf
2022년 8월 29일 1주차. 와이어 프레임 및 회의 진행

2022년 9월 5일  2주차. 와이어 프레임 및 회의, 제작 시작

2022년 9월 12일 3주차, 각자 역할을 분배해 제작



자기가 한 내용들 날짜별로 써주길 바람.


이도훈


원정연


정민수-채팅기능
2022/09/21 채팅목록 탭시 상세채팅방으로 넘어가기, 길게눌렀을떄 다이얼로그 띄우기
2022/09/23 상세채팅방 시작. 텍스트 입력시 db에 넘어감. 아직 채팅내용을 db에서 불러오는건 미완성.


손승호

hfdhfg
권택형 - 로그인 및 메인화면 관리.
2022/09/13  로그인 화면 UI만 대충 구축
2022/09/18  파이어베이스 이메일 로그인 완성, 로그인 되어있을시 바로 메인화면 띄우기 완성
            DB구축 원정연이 푸쉬 안해서 다시 처음부터 만듦ㅋㅋ 


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);

