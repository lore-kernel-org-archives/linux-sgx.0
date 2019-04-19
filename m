Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D47C282DA
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 19:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A790821736
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 19:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="OOCRbmOM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfDSTiX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:38:23 -0400
Received: from mail-eopbgr820109.outbound.protection.outlook.com ([40.107.82.109]:11680
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfDSTiX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 15:38:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfKMSuMXrT0v9/6P9JDL4Kj0PEoUyjrpIwB9oqUMZI8=;
 b=OOCRbmOM3l2dCv0dWv6WD8VAhy/RdzJf2MQ0f4x0hvVSUetuyzNzbzQ99flCv1M/vqFO9+59rqxZxG2wryWCtB0MUyaM1GGsqEDp5FS30DjvMUUeztxR6CfUS6q57iArI3l9JtQuNNWDtgLug0h7HEbvN+C4GF+KE7JQ+/K9nRk=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB3488.namprd11.prod.outlook.com (52.135.112.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Fri, 19 Apr 2019 19:38:19 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.013; Fri, 19 Apr 2019
 19:38:19 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Andy Lutomirski <luto@kernel.org>, "Dr. Greg" <greg@enjellic.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Thread-Topic: [PATCH v20 00/28] Intel SGX1 support
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4A=
Date:   Fri, 19 Apr 2019 19:38:19 +0000
Message-ID: <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
In-Reply-To: <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb3e587e-9c1d-4e8d-f5de-08d6c4fe9328
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600141)(711020)(4605104)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:SN6PR11MB3488;
x-ms-traffictypediagnostic: SN6PR11MB3488:
x-microsoft-antispam-prvs: <SN6PR11MB3488034DBCB73436DD1D6445AA270@SN6PR11MB3488.namprd11.prod.outlook.com>
x-forefront-prvs: 0012E6D357
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39840400004)(376002)(136003)(366004)(199004)(189003)(97736004)(66946007)(53546011)(8676002)(305945005)(229853002)(76176011)(73956011)(26005)(6436002)(7736002)(2906002)(25786009)(3846002)(6486002)(102836004)(68736007)(6506007)(64756008)(6116002)(2616005)(53936002)(5660300002)(66446008)(36756003)(66066001)(7416002)(4326008)(54906003)(386003)(110136005)(86362001)(6246003)(256004)(31686004)(71200400001)(11346002)(476003)(93886005)(52116002)(81166006)(4744005)(186003)(71190400001)(508600001)(316002)(31696002)(99286004)(14454004)(446003)(486006)(81156014)(8936002)(66556008)(66476007)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB3488;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3KQiAj2MCgpF6ujPgDsQPo570x1R5NyeC4dnYxE1d4L2n90OmZ2hrgNk+AsP1T8mRT9MBSE4BSOnLmK4Q1wEuTzIzeo5qOA4/U88zpDdcyr9gAejG6E6GZ/8DMMfytUcxOx6ybjp2kigMlqKpfXpGnb73l76LAxRbwsnj8dJoBdAaSe/HN6OuM+bFLx6FFCunEy/+Ytn35qo45mLFDOk08kWedX9DlZb1Z+5ozu+2gEPSjKJ8u6p/0Jah3ZsjRMn2dVOvQD7q+DcSyyOM6uf4XpeE7qSP3+Y92+PH2+1Feq41PSUfkOrJBb+qPLkL2G2423MuamJNsS0wHGyfopZ4yD8rP4Qqa/bMwwR1lHKgJDbUIAhSnc/NDU45M6iL08SS5os8yETW/thcLDtNzvA223gdITpjrLUTpNW/v/Bcn8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61C5B6756D5C814B8042DA1BE99DFF7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3e587e-9c1d-4e8d-f5de-08d6c4fe9328
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2019 19:38:19.4380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

T24gMjAxOS0wNC0xOSAwODoyNywgQW5keSBMdXRvbWlyc2tpIHdyb3RlOg0KPiBUaGVyZSBhcmUg
bWFueSwNCj4gbWFueSBMaW51eCBzeXN0ZW1zIHRoYXQgZW5mb3JjZSBhIHBvbGljeSB0aGF0ICph
bGwqIGV4ZWN1dGFibGUgdGV4dA0KPiBuZWVkcyB0byBjb21lIGZyb20gYSB2ZXJpZmllZCBzb3Vy
Y2UuICBPbiB0aGVzZSBzeXN0ZW1zLCB5b3UgY2FuJ3QNCj4gbW1hcCBzb21lIHdyaXRhYmxlIG1l
bW9yeSwgd3JpdGUgdG8gaXQsIGFuZCB0aGVuIGNoYW5nZSBpdCB0bw0KPiBleGVjdXRhYmxlLg0K
DQpIb3cgaXMgdGhpcyBpbXBsZW1lbnRlZCBvbiB0aG9zZSBzeXN0ZW1zPyBBRkFJSyB0aGVyZSdz
IG5vIGtlcm5lbCBjb25maWcNCm9wdGlvbiB0aGF0IGNoYW5nZXMgdGhlIHNlbWFudGljcyBvZiBt
bWFwIGFzIHlvdSBkZXNjcmliZS4NCg0KLS0NCkpldGhybyBCZWVrbWFuIHwgRm9ydGFuaXgNCg==
