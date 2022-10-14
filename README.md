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
2022/09/28 채팅입력시 db에 저장.
2022/09/29 상세채팅방 완료. db내용 비동기적으로 불러오고 채팅시작시나 채팅입력시 맨아래로 스크롤기능 (채팅방기능 완료시 이에따라 추가수정필요)


손승호

hfdhfg
권택형 - 로그인 및 메인화면 관리.
2022/09/13  로그인 화면 UI만 대충 구축
2022/09/18  파이어베이스 이메일 로그인 완성, 로그인 되어있을시 바로 메인화면 띄우기 완성
            DB구축 원정연이 푸쉬 안해서 다시 처음부터 만듦ㅋㅋ 
2022/09/24  이메일 인증 및 비밀번호 재설정 완료.
2022/09/25  도훈이형 프2 완성시킴
2022/10/07  로그인쪽 관련 화면 UI 만지는 중
2022/10/10  로그인 화면 전부 완성

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);

