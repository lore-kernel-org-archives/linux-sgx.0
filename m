Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DF0C2BA16
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 07:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815AB20747
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 07:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="WRLoWQ4X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgDGHPb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 03:15:31 -0400
Received: from mail-bn7nam10on2122.outbound.protection.outlook.com ([40.107.92.122]:45376
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbgDGHPb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 03:15:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQjujsZ4W2m0Yc/2wqok8Gh2Aw3Ybo1dFfuVerjLsqG9+zoJjPc3xBlYCDvA7U0kgpJVjp3Ur8cK2YXnG4urMxL9BpXByjwoce+VkWSCRl5xo1ONFuZQM3vskK+S9VKJZUwcP+Gc96OpiXdtAygz7pRzHJRIugY6HJZnmsIDQH6kcQkdffxliueiYBKyt8AY6FKQeWqAjC6d+t5nxGnuT538UcSL2hNlnOj7Lf0v8lpQDI+IyQ8VHSyo2CRY5KIkJrFOfE9duWpFdhqlBXkdjQqbjF/vBF7IYqo/XQTBTvcv7F2J+D9yo+4YK1BSRRbRiRVIhjAzK2zORvREYWhDSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ka45w8z9eTkHLrwPE+TIiZhi5p32cSK0Rdf8S9xcq6Y=;
 b=nYrmQWRAzNTJgiOq0LjXkjixsPcQkCyadCQo5n+MIEbEsldsjZtJKtejL24oSEZqWfXRxxrEAI9mhIHS93z7IrYpFS3CJ62qbbAb+noInZ2bfNEWPtsTnDxd85f3nMPS6bEb/+xMVl2WfVOKMTR/1X6ybvLeGEc6hiS41KIGs1L+ITfZF1UI8lkQs8SKDtFybDurarDrQLtk9VpyEuwbnTUhyF4A1KL5SSJr+Jgld1/I3Cj//0dGVDN3U9XFBsPSRfcLi1OuNVgnwVhMnOTm51//wNfyGJEgzNzqjR3w7lQd7YGDqfWkC/wNr+Pbt2hJkOJPcM593DBOSLE1vQ1aPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ka45w8z9eTkHLrwPE+TIiZhi5p32cSK0Rdf8S9xcq6Y=;
 b=WRLoWQ4XCRwc6L8gXX5daf4/t6sLixlN/F/QeqRoxv+KzvdOmxSgvzYwc8LB1ZkvgOwPyJO/0bziOFqj95ehE9iwPnsiZnWh+bRE38FrPs8fLk4gHJ5uK3Cl4Nk4xWMc4v6VBBFrUKu9Qyy5RgsG/yrwDTXev6r/ZlF6QzTPDQE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4484.namprd11.prod.outlook.com (2603:10b6:a03:1c3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.21; Tue, 7 Apr
 2020 07:15:24 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a%6]) with mapi id 15.20.2878.022; Tue, 7 Apr 2020
 07:15:24 +0000
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <3912545a-1c57-4f95-21a4-566c2bcea194@fortanix.com>
Date:   Tue, 7 Apr 2020 09:15:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CALCETrWkaUS2RU61_4KoNhn3RkW-J+SWiCQTZ623wu4b7snJ0w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms040305010607020005000206"
X-ClientProxiedBy: AM6PR0202CA0042.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::19) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:ba78:aa11:920c:d2e1] (2a02:a210:a441:3083:ba78:aa11:920c:d2e1) by AM6PR0202CA0042.eurprd02.prod.outlook.com (2603:10a6:20b:3a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 7 Apr 2020 07:15:21 +0000
X-Originating-IP: [2a02:a210:a441:3083:ba78:aa11:920c:d2e1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf6c8837-dc46-4f13-1f4a-08d7dac370b0
X-MS-TrafficTypeDiagnostic: BY5PR11MB4484:
X-Microsoft-Antispam-PRVS: <BY5PR11MB4484D543012EFFC4608BC552AAC30@BY5PR11MB4484.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 036614DD9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(39830400003)(396003)(136003)(346002)(376002)(66946007)(235185007)(33964004)(110136005)(5660300002)(7416002)(8676002)(316002)(66476007)(66556008)(81156014)(81166006)(8936002)(54906003)(2906002)(31686004)(6666004)(16526019)(53546011)(186003)(2616005)(508600001)(6486002)(52116002)(31696002)(36756003)(4326008)(86362001);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9wGFlLBxTWL7RfLh6wxmQMAY1QhHqNFcDelxLk0evtOa3ruE/Zq97RZ6cG65si7dtwrp8OmQMZTgHBNjYGhymnet1TK+/x/JMXwLAIPryp0oZVXSKA4onzXm1cIeYUGeV+P5t1xF8RKdJK9IJKhOUSg4cdEzh8RNaclWbOlQ8ce+yUzVwqQ4zyEaEeyQREEKHycGe1P1a1rKk1wjCp3dGWvPG1/jENMOgchnYXIrJPxKirPPuAhdf0snQzimBq25XP4TJAgl0g78k2GDTSdozhQd4heEZRynRrGL2cYc88pg2hwoOA801e9nmpARVJt6WoNeOf4PWNlt2y+DBJgiX7SMfh9mO9aDvkEZ3WEHyPeWpzIdzBaYRgzesWkNKIQ5hRNZpjveyK73zmqB9Qlj/7Tzs1QtXu7OQFcHFwfrqbGiLEoQ1Q0IhInrUDClrMs
X-MS-Exchange-AntiSpam-MessageData: i1zQ5TCuHShR6/ZEZqBnO9Oc2R/KLcPayllmIFiEc3h6YYFnAep3eK7llHvQLP0QtR5itwfClGUtSXxpQByCX/CUbaWQJXomcdMCNGxPeKae6jbkVY5L0+tmQDsVtbd1P5kF5RogS2VDk0Y/NQO1W0QIAqUOzR917mrf6BCmLVPe3Fx9yrANQH3VtwEkUWB6EV6SVA2ZGlxn3vb3c2WYMg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6c8837-dc46-4f13-1f4a-08d7dac370b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2020 07:15:24.2571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSoWNk64PODsdiGq5AL1FW5vCJBhxzHH3FT9tW4ZenOZ0TwZwlxqmHBrMJPAeuhbWzco7DYinOl2fwF4oO502g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4484
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms040305010607020005000206
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-07 01:18, Andy Lutomirski wrote:
> On Mon, Apr 6, 2020 at 2:24 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> On Mon, Apr 06, 2020 at 12:53:41PM -0700, Andy Lutomirski wrote:
>>>> sgxfs is somewhat trivial to implement and has one stakeholder less =
to
>>>> worry about. It is not really a huge stretch.
>>>>
>>>> Overally, I think it is something that we could live with. At least =
it
>>>> is something that does not step on others toes.
>>>>
>>>> Haitao: If we go with sgxfs route, then you can for the moment do wh=
at
>>>> Andy suggested: bind mount it to /dev/sgx.
>>>
>>> That also needs userspace support.
>>>
>>> I=E2=80=99ll start a thread on the udev list.
>>
>> Haven't written any code yet but just by drafting the idea I already
>> pinpointed something.
>>
>> You would add roughly this to the existing codebase:
>>
>> * struct file_system_type sgxfs
>> * struct fs_context_operations sgxfs_ctx_ops
>> * int sgxfs_get_tree()
>> * int sgxfs_fill_super()
>> * const struct tree_descr sgxfs_files[]
>>
>> The files would be defined as like this:
>>
>> static const struct tree_descr sgxfs_files[] {
>>         [SGXFS_ENCLAVE] =3D { "enclave", &sgxfs_encl_ops, /* ? */ },
>>         [SGXFS_PROVISION] =3D { "provision", &sgxfs_encl_ops, /* ? */ =
},
>> };
>>
>> The permissions would need to be completely static, which feels nasty
>> from maintainability viewpoint :-( And I see no gain anywhere.
>>
>> In my opinion udev defining the whole /dev as noexec has zero technica=
l
>> merits. It is same as they would say that "we don't trust our own
>> database". There are no real security benefits as long as dev nodes ar=
e
>> configured correctly.
>=20
> I tend to agree, but it could be seen as a sort-of-valid hardening meas=
ure.

Yeah it seems to me `noexec` is overly broad in not allowing mmap(PROT_EX=
EC). I'd expect it to disallow only execve(), which is fine for /dev.

--
Jethro Beekman | Fortanix


--------------ms040305010607020005000206
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MDcwNzE1MDZaMC8GCSqGSIb3DQEJBDEiBCA68PPu/b5p
ypMbwT1J5iRPUkByrh9bBamCIUMRK/M+SjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAJdex7CP0+orZ6w53BkMEbJ4mAjIYZidstLyp0dUPMyfOXv0m0k4BB+m8
9baMMGPLIU2BvJGM7UCm9lfogcsbkZFvnAlojDvw4hqjGUrxioEpaKm884xTBSkpscZ3g5yr
aTzjJrK15pIcTQmsokMwcCl0029hD940d896I4ADjjnjmM/12GaVW8h0RbTbGAir/ebkvzwJ
bmgUFEF4y/5QVOxza+iz6fHnoo0reHln8D1ds+PHNSdNLAU9dZIVrQ138L6fdSV0BXQJghVd
GG9ifVMdsmktD28RleCWvzIxpZ/sBcOdKPTQC5QdZGQQLkCSiqGDvT72NG/+haEys/EZGgAA
AAAAAA==

--------------ms040305010607020005000206--
