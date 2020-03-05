Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF5CC3F2D1
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 20:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDAC7207FD
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 20:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="NEDTi2ny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCEUeN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:34:13 -0500
Received: from mail-dm6nam10on2095.outbound.protection.outlook.com ([40.107.93.95]:6055
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgCEUeN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 15:34:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ab4Vg3bH4/U7k5Rv8YmYWXwBo6atiSionl7VTw1NuT3pJH64dgvGHrg+tizCEWSjn9pjhYHpy/6aq2Msm05A6AUqad2KU+/6J+hr5FPsI75KPkPzRQBbrsI/4NFC3zW4c8UhAx6WGpzUPydiEwvFuwUiMY+x4hOrEsVmoi5eZ6HL9PLDzBXNhci7gUx1mTnEntNCTJvZM1hIiTt25ktMa4MkxY2biN+MXDTd7Q7mUSE3OMgqCaJabDB7NGskof0kk0k+hL+DvNx5wi9tL6AF2g8VxJ1LrC0J+/OU67LdFYDXIpAtMFUecgiMFzMSZx2FbO8u3Bk941urjqw2i618mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcX2MLxALkS8UJ+MNKLdcJFZMEDR7mqNJaVrqFvQcsU=;
 b=GjaK2AFonCrt01ivgof7R/c/jBS+z71ozssmRIX+bBJYnjr4K+pshp/z4SEl89KqziNXEY9gVP4arxhByF3z6uqTAxAGD/r0RdUZU2Gbyh7crCZjUI+a/LRsOAk+j5Fm6GcGgI6HkJ1SWA4LFdUirE1kPAmSjsWIAIYoWOkoVbwEa9lg0SkJamGx/vmGt2VOxOd2Q4JwTCTm6+tHPV7fPPGz6z4vlEovxHd3ex6IVgWDcrusNDIplTIMotoKgHThxywf1JtgGDvepv8iD4hZJjnQz7K4AFGMHDJpHZp4Vz+kqdw78yjyvZ1EGbFWSxAAve10GpO3O2R8yKfYDDh3dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcX2MLxALkS8UJ+MNKLdcJFZMEDR7mqNJaVrqFvQcsU=;
 b=NEDTi2nyXV8PszRisrL2XiseeqLfs+zXipUNcZTR6xuF19fheZSz5MV7yqd7jYjs36RvS+8IFndRZuyxgDdHpx4dR1BecvRhgnTr/SryM7Gp2YbN57XqEi1sV+Xd/JUgAiadO94+B7uLb+Y2UO+B2vW6NJVMra0G6uY8QJhu18w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BYAPR11MB2919.namprd11.prod.outlook.com (2603:10b6:a03:8d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 20:34:08 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a%4]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 20:34:08 +0000
Subject: Re: x86/sgx: v23-rc2
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>, Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
References: <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
 <20200215072406.GA9958@linux.intel.com>
 <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
 <20200217185512.GA7677@linux.intel.com>
 <20200218104243.GA13967@wind.enjellic.com>
 <20200218155247.GA18374@linux.intel.com>
 <20200219162640.GA29921@wind.enjellic.com>
 <20200220195537.GA23349@linux.intel.com>
 <20200221011913.GA15165@wind.enjellic.com>
 <20200221130009.GB3112@linux.intel.com>
 <20200305195157.GO11500@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <1bd3295e-02b3-ac5c-8545-0bb8cbd4cf48@fortanix.com>
Date:   Thu, 5 Mar 2020 21:34:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200305195157.GO11500@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050107010406070501090202"
X-ClientProxiedBy: AM3PR03CA0055.eurprd03.prod.outlook.com
 (2603:10a6:207:5::13) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.206] (84.81.201.191) by AM3PR03CA0055.eurprd03.prod.outlook.com (2603:10a6:207:5::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Thu, 5 Mar 2020 20:34:06 +0000
X-Originating-IP: [84.81.201.191]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654e6e8e-f932-44e0-0f2c-08d7c1448e53
X-MS-TrafficTypeDiagnostic: BYAPR11MB2919:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2919F0F0CDAEBF12A74F45D5AAE20@BYAPR11MB2919.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39830400003)(366004)(136003)(346002)(376002)(396003)(189003)(199004)(110136005)(81166006)(81156014)(4326008)(8936002)(956004)(52116002)(6666004)(6486002)(31686004)(2616005)(33964004)(508600001)(54906003)(31696002)(66946007)(186003)(2906002)(16526019)(5660300002)(26005)(66556008)(16576012)(316002)(8676002)(53546011)(36756003)(86362001)(66476007)(235185007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2919;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjgesrpSXSB2coqsGSDSqWtbbWIcnI04L+2PybXgLAb3sHhfw/T3F5dtfQdndCQv+96y85kjJj7vgx3XWWbmchWmgfmeKIpN0pM6VWwzIF1sfFLg23GxRDy8PWmFLhLOM9aMy/wZDCmUmcWPa/1sYVPeBqkagvC0CdeJbNOg+WjE9HkTkki9zQ1Fpcc043+U5QQ4uW/lple8jwd08qgEJ32fNtSm8Ahzow1q4puOL2qvGC4aHByiHtQBEpQScv57FB9ajcx+g6iDrVpkd99a841yvLqD7RZLgBbyTMAWomTTvDexfTi984ICaqhErxEH1XUAJGu+Pw09yzUd3SHDRlOIcqoxoa8yyF2JzTPdaxcsKXJvHgu93Htbzwpe3bJuEx0mwF2stXSCw0z9vD5TjVqbK92zOXv8/w/erXRQO2MT5ZaZtc4Sp2B04iIxjoSJ
X-MS-Exchange-AntiSpam-MessageData: nN76iBsLoFdTKvV395pNBVWnkbxdV6fOR2x6qorkU+slpd7mzu0g/ZBmC79M83jj8+1mMdVJamN4LGqyk6k7Vg81Rw+K4mhJuBFdAHbTOd1WElATUGDJAGh2+yV0xCk75ivAR7PEFtLXdYObOlnHkQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654e6e8e-f932-44e0-0f2c-08d7c1448e53
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 20:34:08.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGzvkiR7/oplH2MeFzEnwdqB802xaW+OgsvDTV7L5aRinwbiAfzlZhwAmYHwXAshaSq7r5vsl0XvAuOghrLz6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2919
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050107010406070501090202
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-03-05 20:51, Sean Christopherson wrote:
> On Fri, Feb 21, 2020 at 03:00:31PM +0200, Jarkko Sakkinen wrote:
>> On Thu, Feb 20, 2020 at 07:19:13PM -0600, Dr. Greg wrote:
>>>>> This would seem to imply that the driver is rather firmly architect=
ed
>>>>> on the notion of one open() per enclave, a concept that Jethro seem=
s
>>>>> to have issues with.
>>>
>>>> I don't understand what concept you are talking about.
>>>
>>> If memory serves me correctly, Jethro envisioned a model where a
>>> single open of the SGX driver node would return a file descriptor tha=
t
>>> could then be used to create/load/initialize multiple enclaves.  Your=

>>> clarifications indicate that a separate open will be needed for each
>>> and every enclave instance that will be orchestrated.
>>>
>>> Jethro, if I'm mistating your position on this, please jump in and
>>> clarify.
>>
>> Ah.
>>
>> You are speaking about having a factory to create enclaves and a
>> management interface. I.e. you'd have ioctl to create enclave that giv=
es
>> you a file descriptor to access its management interface.
>>
>> Out of top of my head I cannot recall why this was not favored in the
>> end but generally speaking added complexity should be justified by som=
e
>> considerably strong measures.
>=20
> The primary issue is that having an ioctl() to create enclaves means th=
e
> enclave fd would be an anon inode.

Why would it have to be an anon inode? Can't it just be the same inode as=
 the device file? As I mentioned it just needs to be a different struct f=
ile (since that's what actually owns the enclave). I'm envisioning you st=
ill need to open the device first (once).

Yes, a UDS with SCM_RIGHTS could work, this is similar from a capability =
model perspective. It does make things a lot more complicated if you want=
 to employ userspace security techniques. For example, when using seccomp=
 a common use is to avoid the creation of arbitrary fds. It's rather hard=
 to write a good set of rules for recvmsg with SCM_RIGHTS since the fds a=
re passed from outside. Whitelisting a single ioctl is much easier. Also,=
 you'd need to create a whole separate process whose job it is to hand ou=
t these enclave fds. That process still needs to be privileged and would =
probably need its own set of seccomp rules.

--
Jethro Beekman | Fortanix


--------------ms050107010406070501090202
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMDUyMDM0MDFaMC8GCSqGSIb3DQEJBDEiBCAaZDbsdOzk
vFg66XMM2VSK7zbZLXk7QbAt3zPosxb8gjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAuOUHddl48y5q5YTUeL+nVuBzLJoxqUtKGUQSQaNvbPvAdl0L055t3IZW
pNS90llzGx/RVIvJ8W9PLvv7+3jK5eYjRrhZPKXZD16N5ULguqhm0Asg6UpygxFPbOppepVR
JdLvWSACr3dntirmS6T0/sMaY50r4D+vFLIKKFiMpiaYoBjwuJIKx8fILoOoWUE027IKvqS/
8prRR02vEC10gj1V77n+YlGwCygyu1vMhCGW128RTB1SDwdTZ8cX3XdlW5AlDLYky68QKldR
SCzryir2oIfIQjKCAJo95wAO1uu8r1QvosnXz3nq/oLLTb0FcfShcNQOu4F7nMkzYF1CYQAA
AAAAAA==

--------------ms050107010406070501090202--
