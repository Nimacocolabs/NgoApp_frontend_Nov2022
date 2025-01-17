import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ngo_app/Constants/CommonMethods.dart';
import 'package:ngo_app/Constants/CustomColorCodes.dart';
import 'package:ngo_app/Constants/StringConstants.dart';
import 'package:ngo_app/CustomLibraries/CustomLoader/RoundedLoader.dart';
import 'package:ngo_app/CustomLibraries/ImagePickerAndCropper/image_picker_handler.dart';
import 'package:ngo_app/Elements/CommonAppBar.dart';
import 'package:ngo_app/Elements/CommonButton.dart';
import 'package:ngo_app/Elements/CommonLabelWidget.dart';
import 'package:ngo_app/Elements/CommonTextFormField.dart';
import 'package:ngo_app/Models/CampaignItem.dart';
import 'package:ngo_app/Utilities/LoginModel.dart';

import 'FormFour.dart';

class FormThreeScreen extends StatefulWidget {
  @override
  _FormThreeScreenState createState() => _FormThreeScreenState();
}

class _FormThreeScreenState extends State<FormThreeScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _fullName;
  String _healthIssue;
  String _minDays;
  String _hospital;
  String _city;
  File _coverImage;
  List<File> _paths;

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _minDaysController = new TextEditingController();
  TextEditingController _healthIssueController = new TextEditingController();
  TextEditingController _hospitalController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  String coverImageUrl = "";

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    initFields();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fullNameController.dispose();
    _minDaysController.dispose();
    _healthIssueController.dispose();
    _hospitalController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = new FocusNode();
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(colorCodeGreyPageBg),
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), // here the desired height
            child: CommonAppBar(
              text: "Start a Fundraiser",
              buttonHandler: _backPressFunction,
            ),
          ),
          body: Container(
            color: Colors.transparent,
            height: double.infinity,
            width: double.infinity,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(_blankFocusNode);
              },
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: FractionalOffset.centerLeft,
                          child: Text(
                            "Beneficiary Information",
                            style: TextStyle(
                                color: Color(colorCoderBorderWhite),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        _buildImageSection(),
                        _buildCategorySection(),
                        Padding(
                          child: CommonTextFormField(
                              controller: _fullNameController,
                              hintText: "Patients Full Name",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _fullName = val,
                              validator: CommonMethods().nameValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              controller: _healthIssueController,
                              hintText: "Health Issue",
                              maxLinesReceived: 1,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _healthIssue = val,
                              validator: CommonMethods().nameValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Padding(
                          child: CommonTextFormField(
                              controller: _hospitalController,
                              hintText: "Hospital Name",
                              maxLinesReceived: 2,
                              maxLengthReceived: 150,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _hospital = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "City",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _cityController,
                              hintText: "City",
                              maxLinesReceived: 3,
                              maxLengthReceived: 200,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              onChanged: (val) => _city = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .01),
                        Visibility(
                          child: CommonLabelWidget(
                            label: "Minimum days for collection",
                          ),
                          visible: LoginModel().isFundraiserEditMode,
                        ),
                        Padding(
                          child: CommonTextFormField(
                              controller: _minDaysController,
                              hintText: "Minimum days for amount collection",
                              maxLinesReceived: 1,
                              maxLengthReceived: 3,
                              textColorReceived: Color(colorCodeWhite),
                              fillColorReceived: Color(colorCoderGreyBg),
                              hintColorReceived: Colors.white30,
                              borderColorReceived: Color(colorCoderBorderWhite),
                              isDigitsOnly: true,
                              onChanged: (val) => _minDays = val,
                              validator: CommonMethods().requiredValidator),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        Visibility(
                          child: _buildAttachFileSection(),
                          visible: !LoginModel().isFundraiserEditMode,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 50.0,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: CommonButton(
                buttonText: "Next",
                bgColorReceived: Color(colorCoderRedBg),
                borderColorReceived: Color(colorCoderRedBg),
                textColorReceived: Color(colorCodeWhite),
                buttonHandler: _nextBtnClickFunction),
          ),
        ),
      ),
    );
  }

  void _backPressFunction() {
    print("_sendOtpFunction clicked");
    Get.back();
  }

  _buildImageSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      alignment: FractionalOffset.center,
      width: double.infinity,
      height: 200,
      color: Colors.transparent,
      child: Container(
        height: 180.0,
        width: double.infinity,
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: new BoxDecoration(
              color: Colors.transparent,
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
              child: SizedBox.expand(
                child: showImage(),
              ),
            ),
          ),
          // Positioned(
          //   right: 0.0,
          //   bottom: 0.0,
          //   child: Container(
          //     child: InkWell(
          //       child: Image.asset(
          //         ('assets/images/ic_camera.png'),
          //         height: 45,
          //         width: 45,
          //       ),
          //       onTap: () {
          //         imagePicker.showDialog(context);
          //       },
          //     ),
          //   ),
          // )
        ]),
      ),
    );
  }

  Widget showImage() {
    if (LoginModel().isFundraiserEditMode) {
      return Center(
        child: _coverImage == null
            ? Container(
                color: Colors.black12,
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: coverImageUrl,
                  placeholder: (context, url) => Center(
                    child: RoundedLoader(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(0),
              )
            : Container(
                height: 180.0,
                width: double.infinity,
                child: Image.file(_coverImage, fit: BoxFit.fill, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  );
                }),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(80.0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover),
                ),
              ),
      );
    } else {
      return Center(
        child: _coverImage == null
            ? Container(
                color: Colors.black12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                      InkWell(
                        child: Image.asset(
                          ('assets/images/ic_camera.png'),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        onTap: () {
                          imagePicker.showDialog(context);
                        },
                      ),
                      // Image(
                      //   image: AssetImage('assets/images/no_image.png'),
                      //   height: double.infinity,
                      //   width: double.infinity,
                      // ),
                      flex: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        "Upload beneficiary image",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0),
                      ),
                    )
                  ],
                ),
                padding: EdgeInsets.all(5),
              )
            : Container(
                height: 180.0,
                width: double.infinity,
                child: Image.file(_coverImage, fit: BoxFit.fill, errorBuilder:
                    (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                  return Container(
                    child: Image.asset(
                      ('assets/images/no_image.png'),
                      fit: BoxFit.fill,
                    ),
                  );
                }),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(80.0)),
                  image: new DecorationImage(
                      image: new AssetImage('assets/images/no_image.png'),
                      fit: BoxFit.cover),
                ),
              ),
      );
    }
  }

  void _nextBtnClickFunction() {
    print("_clearBtnClickFunction clicked");
    if (LoginModel().isFundraiserEditMode) {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());

        if (_coverImage != null) {
          LoginModel().startFundraiserMap["beneficiary_image"] = _coverImage;
        }
        LoginModel().startFundraiserMap["patient_name"] = _fullName.trim();
        LoginModel().startFundraiserMap["health_issue"] = _healthIssue.trim();
        LoginModel().startFundraiserMap["hospital"] = _hospital.trim();
        LoginModel().startFundraiserMap["city"] = _city.trim();
        LoginModel().startFundraiserMap["no_of_days"] = _minDays.trim();

        Get.to(() => FormFourScreen());
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
      }
    } else {
      if (_formKey.currentState.validate()) {
        if (_coverImage != null) {
          if (_paths != null) {
            FocusScope.of(context).requestFocus(FocusNode());

            LoginModel().startFundraiserMap["beneficiary_image"] = _coverImage;
            LoginModel().startFundraiserMap["patient_name"] = _fullName.trim();
            LoginModel().startFundraiserMap["health_issue"] =
                _healthIssue.trim();
            LoginModel().startFundraiserMap["hospital"] = _hospital.trim();
            LoginModel().startFundraiserMap["city"] = _city.trim();
            LoginModel().startFundraiserMap["no_of_days"] = _minDays.trim();
            LoginModel().startFundraiserMap["upload_documents"] = _paths;

            Get.to(() => FormFourScreen());
          } else {
            Fluttertoast.showToast(
                msg: "You need to add at-least one document");
          }
        } else {
          Fluttertoast.showToast(msg: "Main image is mandatory");
        }
      } else {
        Fluttertoast.showToast(msg: StringConstants.formValidationMsg);
        return;
      }
    }
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }

  _buildAttachFileSection() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: FractionalOffset.centerLeft,
          padding: const EdgeInsets.fromLTRB(0.0, 0, 5.0, 0.0),
          child: TextButton.icon(
              icon: Icon(Icons.attach_file),
              label: Text('Attach Documents'),
              onPressed: () => _openFileExplorer()),
        ),
        SizedBox(
          height: 5,
        ),
        ListView.builder(
            itemCount: _paths != null && _paths.isNotEmpty ? _paths.length : 0,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) => this._buildRow(index))
      ],
    );
  }

  void _openFileExplorer() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
          allowMultiple: true);
      if (result != null) {
        List<File> tempPaths = result.paths.map((path) => File(path)).toList();
        if (_paths != null) {
          _paths.addAll(tempPaths);
        } else {
          _paths = tempPaths;
        }
      } else {}

      if (_paths != null) {
        if (_paths.length > 8) {
          _paths.removeRange(7, _paths.length - 1);
          Fluttertoast.showToast(
              msg: "Maximum of 8 attachments can upload at a time");
        }
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      // _fileName = _paths != null ? _paths.keys.toString() : '...';
    });
  }

  _buildRow(int index) {
    final String name = _paths.toList()[index].toString().split('/').last;
    String fileSize =
        CommonMethods().formatBytes(_paths[index].lengthSync(), 2) ?? "";

    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/ic_file.png'),
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            flex: 4,
          ),
          Expanded(
            child: Text(" " + fileSize + " ",
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: new TextStyle(
                    fontSize: 10.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500)),
            flex: 1,
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            child: Image.asset(
              'assets/images/ic_close_round.png',
              width: 20.0,
              height: 20.0,
            ),
            onTap: () {
              _paths?.removeAt(index);
              setState(() {});
            },
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  _buildCategorySection() {
    return Padding(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          maxWidth: double.infinity,
          minHeight: 50,
        ),
        child: Container(
            alignment: FractionalOffset.centerLeft,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              color: Color(colorCoderGreyBg),
              border: Border.all(color: Color(colorCoderBorderWhite), width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Text(
              getCampaignSelected(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0),
            )),
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
    );
  }

  String getCampaignSelected() {
    if (LoginModel().startFundraiserMap != null) {
      if (LoginModel().startFundraiserMap.containsKey("campaignSelected")) {
        CampaignItem campaignItem =
            LoginModel().startFundraiserMap["campaignSelected"];
        if (campaignItem != null) {
          return campaignItem.title;
        }
      }
    }
    return "n/a";
  }

  @override
  userImage(File _image) {
    if (_image != null) {
      setState(() {
        this._coverImage = _image;
      });
    } else {
      Fluttertoast.showToast(msg: "Unable to set image");
    }
  }

  void initFields() {
    if (LoginModel().isFundraiserEditMode) {
      if (LoginModel().itemDetailResponseInEditMode != null) {
        if (LoginModel().itemDetailResponseInEditMode.success) {
          _fullName = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .patientName;
          _fullNameController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .patientName;

          _healthIssue = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .healthIssue;
          _healthIssueController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .healthIssue;

          _hospital = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .hospital;
          _hospitalController.text = LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .hospital;

          _city =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.city;
          _cityController.text =
              LoginModel().itemDetailResponseInEditMode.fundraiserDetails.city;

          String val = CommonMethods().getDateGap(LoginModel()
              .itemDetailResponseInEditMode
              .fundraiserDetails
              .closingDate);
          _minDays = val;
          _minDaysController.text = val;

          if (LoginModel().itemDetailResponseInEditMode.baseUrl != null) {
            if (LoginModel().itemDetailResponseInEditMode.baseUrl != "") {
              if (LoginModel().itemDetailResponseInEditMode.fundraiserDetails !=
                  null) {
                if (LoginModel()
                        .itemDetailResponseInEditMode
                        .fundraiserDetails
                        ?.beneficiaryImage !=
                    null) {
                  if (LoginModel()
                          .itemDetailResponseInEditMode
                          .fundraiserDetails
                          ?.beneficiaryImage !=
                      "") {
                    coverImageUrl =
                        LoginModel().itemDetailResponseInEditMode.baseUrl +
                            LoginModel()
                                .itemDetailResponseInEditMode
                                .fundraiserDetails
                                ?.beneficiaryImage;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
