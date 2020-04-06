Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0F2C2BA18
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 06:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 072F12074F
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 06:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="WZvhG0eR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDFGmr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 02:42:47 -0400
Received: from mail-dm6nam12on2110.outbound.protection.outlook.com ([40.107.243.110]:8704
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgDFGmr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 02:42:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IX1L4zpwHk1bhASVPsy5H5hnwMGXHYaGk4qRkXb/d/pMHmagEXd0/zvpfai3r4JGQr0iabw7i9PsZpDP/SpoTFtAeACh2IahGd0hMdiLFAGHFSCPeMJVElsV+C5EjkrkZZBAFGke8Wfc6yWx1coCcLvEUwO4EzBpGimSsME2f7rwxvaUIyZcJwGun8KcXKgw2IFx9wiKtu2FaqWtebAE1aSCVMQk3gFbDbuK6OOmaBbLLb2YZkipsVyjWPTRMvWxIFHn3kVFKC14WCHiIs5Qx8/hshOc5fm8UMFH7rk+fv1DYGdzo+1GSRRRdqT/ajScpuhVgcKnWzWDYLctN47KmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdlltjrg0AenvcQ4Hzey/Ay1MJ/IMDzt+jIQokGH1gQ=;
 b=QXiY8/3uyNccyEfQgoAzJQuBLEk/KFWgRp+j/TqEkSzq4Vs90i8JTJ2PYvFLv80lgrdihOp3W88/5ZnsSL0aDac8UBH5WrLjtTS2eT/pZc6tpilkQCZnsSVFFR3XVFCvkpUnPI/I73bxCkIchZQeVsPX4otMdM0gFP+MOENpegSldMivU4m5AJ/jl4x53nMhLNOdBJ1bK0DguW0iIXQBU/EqVjA5TU54Lunh3GGA9OzI+t3TrYGHrh+GrADTqh9K54MElZlArk+/2rlZNnvmyr+T1zAZLGqwuDRhkAWHjcxHigOUyXRX8/ITKbXgHTUB71kZs3IfAc87qJ6fBx7bew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdlltjrg0AenvcQ4Hzey/Ay1MJ/IMDzt+jIQokGH1gQ=;
 b=WZvhG0eRP4x6BW/HWcGYiOw2ZqLbuHc4BAfsQJPfrD69o6U8g3lTFlAgua2cc1dFSfJwLLgVbeRVO/I3rx02VdXjUvDz7+0KbyDdMl5DekG4bmPmtN/C7Shr+y9Xh+9Qz+SKi0gemUHeaL6nK50X/wKQYpZuU6ktHheD18mAuhs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4038.namprd11.prod.outlook.com (2603:10b6:a03:18c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Mon, 6 Apr
 2020 06:42:42 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a%6]) with mapi id 15.20.2878.017; Mon, 6 Apr 2020
 06:42:42 +0000
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Topi Miettinen <toiwoton@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
 <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
 <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <e55d56bd-7960-d89a-712e-49daadccb88e@fortanix.com>
Date:   Mon, 6 Apr 2020 08:42:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090408020308040509030307"
X-ClientProxiedBy: AM6P194CA0081.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::22) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:ba78:aa11:920c:d2e1] (2a02:a210:a441:3083:ba78:aa11:920c:d2e1) by AM6P194CA0081.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 06:42:39 +0000
X-Originating-IP: [2a02:a210:a441:3083:ba78:aa11:920c:d2e1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9817d11-897f-4964-7473-08d7d9f5b4bb
X-MS-TrafficTypeDiagnostic: BY5PR11MB4038:
X-Microsoft-Antispam-PRVS: <BY5PR11MB4038398ED677EE9FE691473EAAC20@BY5PR11MB4038.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(346002)(39830400003)(136003)(396003)(366004)(2616005)(66476007)(66556008)(6486002)(66946007)(235185007)(7416002)(5660300002)(31686004)(2906002)(33964004)(52116002)(6666004)(36756003)(8676002)(54906003)(508600001)(8936002)(31696002)(186003)(81166006)(316002)(16526019)(81156014)(110136005)(4326008)(86362001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y6b/QYphp1RyFbo1AAzc2OpqCnWaVyah/YdimUAWp0HI0hmL9JDdDIwX8v2silObQzEdcp1wTOy42mf6/kNyvhZMuhcl4i3joWNRkrC6maFjrdxgJs8tUeHVECDyUwP0xCPg5MQLSHUObSQ8DA6JcOdcRDuePd7pRRJmHpN3L5TLOO02Hl/MlyW501/1me2e9fs07TI4gY51IDyB16rUOh1SH/943QkRBPctpY2Lf0fwB7PLg2nQjV1l6v7KAtF+4MgT1liYTTPPwUDITc+hM2beRSrZYoKTfecUydcrO7r4rZA/a8dLWKCSoWpO3akgLRH0pg/3H2u6A6f4fD1x97ZdkJYfm30MPWlK1Cy3VDA1oRZpDO7U0Wj+vdXeBzoueA5VytefkH1JakfKVWolvGKe9M6ZTfcoQNy42RDfZ7sq/jAZMWBcjnFS6Kr5ADiB
X-MS-Exchange-AntiSpam-MessageData: vuQapUpYz+sHFmn6w1YmdIZ/tLiW4RSXrtIQ2cb1aGIHxba5q73yimlpY1zxpf0WAWTDXX48nCGTES3E1fP8q1jjj1mhucmjTnrV7dtF+n2/2F99RQXIUyFPhcCvNj4sxd1fL/wuNbBMfByQ5TSo8Nfl0dgZxz2Yza5k6gcLe1IT4ZKDvuh76KNSaqDuR2eCMC0PafzMsvYIEkOCPROMfA==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9817d11-897f-4964-7473-08d7d9f5b4bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 06:42:42.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR05QUkV7W0ZjA8eglM1unS2L0U2HN4A5IlOemYht8GXzde/jjfEdiNC47X0UB5Rp0BI8bYmEOINQSqMYsAAfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4038
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090408020308040509030307
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a s=
imilar exception as with v86d and grant exec to /dev.

I'm not sure this is a reasonable approach. Expect most devices with an I=
ntel processor will have the SGX device going forward. Then, no one is us=
ing noexec, so why have this logic at all?

--
Jethro Beekman | Fortanix


--------------ms090408020308040509030307
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MDYwNjQyMzFaMC8GCSqGSIb3DQEJBDEiBCBBBduipux3
YJ9iR/D4BLpPPvYuDf2FVIgYyNEEh0oPozBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAD6k6+PzeTeXa2T5s3ZuOQkvIInMzj4zKFZcfsXnWpYpex53TNefBQ6d0
FhxKgKIAORkIhWzE4dtheuw6Z08JqzAmYeGHEN7pExqdO+nh84zSmshy4xlvWdq/Otse5UJQ
ucrpic+5d4EbXorpDwhQwjsLjAZ+rgcjV7W9t442lRGnAaP2GWmmy2eCCzAqfw04Qj9kIhTl
NqggpapWDz1y/1qe7rgib9oQ1t2y187v5DhIs0Ipzdk5S9SqL6WwPk7XqQDzmfJPSZlrzXVQ
Ac0EQz8W/EsAbdK8DZc/LsAH2ZnaNFSrxCFhJ2va7JkIaWv2p6H5r/cTkiuP/RdqrLZhIAAA
AAAAAA==

--------------ms090408020308040509030307--
