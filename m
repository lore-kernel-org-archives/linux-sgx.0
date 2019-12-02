Return-Path: <SRS0=wzDQ=ZY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5589DC432C3
	for <linux-sgx@archiver.kernel.org>; Mon,  2 Dec 2019 09:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 142DC20833
	for <linux-sgx@archiver.kernel.org>; Mon,  2 Dec 2019 09:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="mwBZZgU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfLBJYQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 Dec 2019 04:24:16 -0500
Received: from mail-eopbgr790093.outbound.protection.outlook.com ([40.107.79.93]:46976
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbfLBJYQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 2 Dec 2019 04:24:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdlhjwQlvGwFpiGHqyxzuh/DzjK5dJakS8mV+PicbidyeUsYbB+NJSnAKXvhIkCiIuGaEx4WldcngnKHp5DgSISw1LK9nPXQrYc8cLqjt2CPBU/yxaTNZotuqKR0Zl3n5K7CM1sAhTmlJ0oLBGobPMvEOFpoQwhc0ohzXIXyhaskdDvySi4iyWP2bXBX9pfbIJMYj+64IpDB6zrlAX9ZL+RKqL9jjdxZQEi4hLccAq1pwWbMD1bClopBMOzr2zE4/OizOPzrclKAf7hVNCYMsrdMeDwV2cau1hNTEnhGm5ScPVgw7BQf2MNS+fVS42eDPLPOfogBL09CSfTJGFa3YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKgbYvkqn3yBjxhACztFdH5iY1ZTSC8CPACUBQwxorg=;
 b=lmXRUdSV35Oaedr/iY/gqgwnRx+Txc940YzZ5AZZLdSWGQhsSE0A/5SM1HKXPDZjmSXD6x6e92jngXnEFiolgCC3fuhweO/BpPTVSq6Fh1GTbWMm59xyq4eYz7uSJDodBCO2ArHP4bb0HgOuqKCEk4Bj8ohg/1JHh8jHKmiNckhx3DuHglwBn0ZXlVj4F6fmBxPpOyJAVI5kchGtJY5K9QHNlhxSWn5nKY+FyuuHaRsVzxkvK93kOJbUScMwYLRyKg6cO0WI9ILwH8vXNU3y468jfW6jyGnWBYbwdZ5G1b5q/kY7Vo4x8K+icJHt2jV6jux06baKBpmqAF2yogbJqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKgbYvkqn3yBjxhACztFdH5iY1ZTSC8CPACUBQwxorg=;
 b=mwBZZgU97wnnFkPZu0FuDDYLZiATjLcizvW/T66sP6qxc/cyatr4fo5BN3A53+lQracPY3zooutM+dKk2lbd3qOX6GNI0oCwE0galZPNiwubvPhGQNGiWE87n68l0gNoj5Lp6w2xqfxSsGB/Wg7/IIvQ1VFHlm9bV2pqz183bY8=
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB2821.namprd11.prod.outlook.com (52.135.228.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Mon, 2 Dec 2019 09:24:10 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::84:fa73:ee:803e]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::84:fa73:ee:803e%3]) with mapi id 15.20.2495.014; Mon, 2 Dec 2019
 09:24:09 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     "Dr. Greg" <greg@enjellic.com>, Neil Horman <nhorman@redhat.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "cedric.xing@intel.com" <cedric.xing@intel.com>,
        "puiterwijk@redhat.com" <puiterwijk@redhat.com>
Subject: Re: [PATCH v24 01/24] x86/sgx: Update MAINTAINERS
Thread-Topic: [PATCH v24 01/24] x86/sgx: Update MAINTAINERS
Thread-Index: AQHVpwqrer2pSQz2z0+JP3o/9X8zRKei76AAgADZxoCAAsz6AA==
Date:   Mon, 2 Dec 2019 09:24:09 +0000
Message-ID: <be9966a6-b57c-9e5d-ec7e-c642d4897679@fortanix.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-2-jarkko.sakkinen@linux.intel.com>
 <20191130013824.GA28617@hmswarspite.think-freely.org>
 <20191130143751.GA31365@wind.enjellic.com>
In-Reply-To: <20191130143751.GA31365@wind.enjellic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0249.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::21) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.61.132.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38135f1e-1edd-4a64-2654-08d7770962c7
x-ms-traffictypediagnostic: BYAPR11MB2821:
x-microsoft-antispam-prvs: <BYAPR11MB2821E55EA3BB120CDEC209A5AA430@BYAPR11MB2821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0239D46DB6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(39830400003)(376002)(189003)(199004)(7736002)(6436002)(305945005)(6486002)(7416002)(99286004)(76176011)(6512007)(386003)(102836004)(26005)(6506007)(53546011)(52116002)(66446008)(64756008)(66556008)(66476007)(66616009)(66946007)(229853002)(186003)(31686004)(25786009)(54906003)(316002)(110136005)(5660300002)(36756003)(71200400001)(31696002)(256004)(3846002)(2616005)(11346002)(4001150100001)(6246003)(71190400001)(446003)(81166006)(81156014)(8676002)(8936002)(6306002)(66066001)(4326008)(14454004)(6116002)(966005)(508600001)(86362001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2821;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIdJW4xrlfEpWs/bRbRahqfbhS6Dpi3E0FrhdvOCWA1WRJOA0cvkMSZOtJbEuEjvEUDmsV2X55n//W76TGqPjO16/ky6TDMEvP5mCg6320LwkRoRrl3BuWin9XUcj6bXRGv10FqFKZTgVhtHE6ZtvToL1J+xGrwpKVlypCbnQyTBbX5/fte93IBFzgNh21jkU9vVD0XePbsfpfoU0mYh4YpajlGT/tAxUol6Ed+8Cgb+Ji8ZiZKv+Oa753XeCWq0oIj6I/OHb8ijZ5e1tAoqe8llbSTAXKYAXlPQU3H4b8fTUmlPfZaom+0VN1JdCObdIUG/GSsLkEHfRN3sMPQszVm7r9EJu+D4pMt1WjNzOGFgOEpFlJZnGEsWA6x7yreLLxZsuZTA1oQAenP3fvryeOF27TPUhDc3f9y75CfAsAGsxCrw1VZgIH3HT42oUWxUTElcg0nhNPLflMHpVDVOM4kmDRNzHl7vTgWfeBXQlmM=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000304070700030301030709"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38135f1e-1edd-4a64-2654-08d7770962c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2019 09:24:09.4212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2CCcp7c4ATWXu6dkyONylHRd8SmFgupOeoVBZ46S8ij6z9sMYP95cr3NIXA5uUVFCEzjB1D+4eCg/KS84h5hNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2821
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000304070700030301030709
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

All patches were sent: https://www.spinics.net/lists/kernel/threads.html#=
3333086

--
Jethro Beekman | Fortanix

On 2019-11-30 15:37, Dr. Greg wrote:
> On Fri, Nov 29, 2019 at 08:38:24PM -0500, Neil Horman wrote:
>> On Sat, Nov 30, 2019 at 01:13:03AM +0200, Jarkko Sakkinen wrote:
>=20
> Good morning, I hope the weekend is going well for everyone.
>=20
>>> Add the maintainer information for the SGX subsystem.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>> ---
>>>  MAINTAINERS | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 0154674cbad3..08a67272ed14 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -8512,6 +8512,17 @@ F:	Documentation/x86/intel_txt.rst
>>>  F:	include/linux/tboot.h
>>>  F:	arch/x86/kernel/tboot.c
>>> =20
>>> +INTEL SGX
>>> +M:	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>> +M:	Sean Christopherson <sean.j.christopherson@intel.com>
>>> +L:	linux-sgx@vger.kernel.org
>>> +S:	Maintained
>>> +Q:	https://patchwork.kernel.org/project/intel-sgx/list/
>>> +T:	git https://github.com/jsakkine-intel/linux-sgx.git
>>> +F:	arch/x86/include/uapi/asm/sgx.h
>>> +F:	arch/x86/kernel/cpu/sgx/*
>>> +K:	\bSGX_
>>> +
>>>  INTERCONNECT API
>>>  M:	Georgi Djakov <georgi.djakov@linaro.org>
>>>  L:	linux-pm@vger.kernel.org
>>> --=20
>>> 2.20.1
>=20
>> Wheres patch 12/24?
>=20
> Out here in North Dakota we are currently missing the following
> patches out of the series:
>=20
> 11/24
> 13/24
> 18/24
> 19/24
> 20/24
>=20
> The missing parts are consistent on both the linux-kernel and
> linux-sgx lists, ie we have duplicates of every patch but are
> completely missing the noted patches.
>=20
> Given gregkh's comments, it would seem to do little good to re-post
> the series, given the fact the device model doesn't appear to be
> acceptable in its current form.
>=20
>> Neil
>=20
> Have a good weekend.
>=20
> Dr. Greg
>=20
> As always,
> Dr. Greg Wettstein, Ph.D    Worker / Principal Engineer
> IDfusion, LLC
> 4206 19th Ave N.            Specialists in SGX secured infrastructure.
> Fargo, ND  58102
> PH: 701-281-1686            CELL: 701-361-2319
> EMAIL: gw@idfusion.org
> -----------------------------------------------------------------------=
-------
> "Artifical Intelligence stands no chance against Natural Stupidity."
>                                 -- John Henders
>=20


--------------ms000304070700030301030709
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xOTEyMDIwOTI0MDBaMC8GCSqGSIb3DQEJBDEiBCCvJShy35Ow
ZhArmd5YgO+AD1zXrarJyeAka4MjWsQz3jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAjjaRPCAI4qD9JZjFgCZVHcU2B3UKEajGOuYdgnggyMMgAfWIck2fVWzd
8ePFRvBpXaOlSslRxdwbembrARwJm6JlJWJd6pDQEIQUOpQWZWzB1spvqRaAtv3OxXFLv6Ek
kGMeQiuUIqjhLExAYstXgRPtqng7y9+lConKbAnwEq6dkjALLexnwvvGKpsWlMjsQ0BAmAKr
zd+Z0hwvu89RvweW1lMxo5SKz6ga308VJtwV+wcBCCmbob6l4V/qTTLcaylNYIkdayOO+5tK
fGEwuuSzlhHwBZnAkLq4RrCowF7TUeD3pVO+1SiXLyQLfCd+teM6i5Kbe3py/gs6tCPWWQAA
AAAAAA==

--------------ms000304070700030301030709--
