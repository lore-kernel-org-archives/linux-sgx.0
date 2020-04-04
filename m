Return-Path: <SRS0=o5ed=5U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B06BC2BA16
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 05:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 022222064A
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Apr 2020 05:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="mKpAGoyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgDDFqz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 4 Apr 2020 01:46:55 -0400
Received: from mail-dm6nam10on2109.outbound.protection.outlook.com ([40.107.93.109]:61729
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgDDFqz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 4 Apr 2020 01:46:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGGY2AdkD3mBRkqnjlp8HwnK7xphE2vb04Ga1W7L19x1sO/3Q+GTuTJRbQA57VAIy+QUiQrMevNZVlPPdqiI5ZwJU7DLtyT5wiBL6Zh70FeTcwGFzDijIuSi0ZpodbYt3Wa3bdfArH6gpwc/r2AMe7xuA9koavZ+HQEOH2KxPoHGvkri9QrahBtztHiBQQ9iZd6Cweejph3mSUJBU09XrpPvsZePoW0YtgwPZ+ac34oUdwTubNTJGS+IM0vZNfhIM1RrLl3pO8guLrRW00UVQnkKS1Ba8Hrg+NIl/kjp+7G4wwbhNAgosUTWgiTjYGHJcyWI30f86Mgrw3L8h8tNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL79W2twSIxuyb5/r0x07TPte9b+f8bj6Ixkr2Bwrwg=;
 b=JHuHX7tGTnteyiHKprmSenZ2MO6pC5aeRMfjLsw0Clvlh61ikEEEzzxLNKOU7qutuvypp1PlUzvPfVp+o5RyQk5DCuzOGsmTSlN15CaVdHtT9+CpuGHGb+pOpuhGtKI3gw6xRI7WAvJ9gnT++706Dm1rw2GSneehJSM1C/l0tRX4Gc8hlJxp2g8f2QLbxt/HB84c/qiA9YSUH8/4WFzPi74G0dZjW7LycNakE3Zbz+rJA0GOjkRqmh/BbrhCKVnmhc/s4V0hrAdWSa1UqMJMJyqdFb2QPQvdpHmd+mIP/04kpISvYw2WnFY6kPHnqs+K9LlxG2VZgZI5EQ6RxDV/tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL79W2twSIxuyb5/r0x07TPte9b+f8bj6Ixkr2Bwrwg=;
 b=mKpAGoyttqLebjLW7D3KcqrZeeDu2r5UTHsSPXsXmKagsuG8ofTz0Xbvf+zsVW3C7VF0jk6VZEmS7znobpkGHduiTdeNpDXUUJFQgqIGGH+6Eaid8ViGfZzXW9SOCdVR/hwXJjXjEjZO6YAZ71Hx6XypD4XIZWX2dVyFUDvCS1M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB3864.namprd11.prod.outlook.com (2603:10b6:a03:18f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Sat, 4 Apr
 2020 05:46:51 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::1506:a274:4d30:741a%6]) with mapi id 15.20.2878.017; Sat, 4 Apr 2020
 05:46:50 +0000
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk, toiwoton@gmail.com
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
Date:   Sat, 4 Apr 2020 07:46:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020105000104040803040301"
X-ClientProxiedBy: AM3PR07CA0112.eurprd07.prod.outlook.com
 (2603:10a6:207:7::22) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:a210:a441:3083:ba78:aa11:920c:d2e1] (2a02:a210:a441:3083:ba78:aa11:920c:d2e1) by AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.6 via Frontend Transport; Sat, 4 Apr 2020 05:46:48 +0000
X-Originating-IP: [2a02:a210:a441:3083:ba78:aa11:920c:d2e1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 912236bb-361a-4602-4e75-08d7d85b925d
X-MS-TrafficTypeDiagnostic: BY5PR11MB3864:
X-Microsoft-Antispam-PRVS: <BY5PR11MB38643AB43D0682535E5CA536AAC40@BY5PR11MB3864.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03630A6A4A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(376002)(136003)(366004)(39830400003)(396003)(316002)(66556008)(66946007)(5660300002)(235185007)(2906002)(7416002)(6486002)(86362001)(66476007)(31696002)(36756003)(966005)(508600001)(4326008)(54906003)(31686004)(2616005)(16526019)(110136005)(8676002)(6666004)(81156014)(81166006)(8936002)(53546011)(186003)(52116002)(33964004);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJmQG4QLk57zny6c5Cd3yJVOk+FUApMBZSNy68Z7EbMljxXHTAAMdjPRS2wOoy67Qu+w79UT7xL2wvcvaQQrfdfC3Sih8twaHAkDx0beF3KZ3SN2W2mktX37gjRX21E5+WMraFTlYh2z61SBRXRmBpgU6QT34hQE0x4Jn4NVEcrdpBgJSDuiv0nI2WCR7vKkE2/mE5IUXpzlPkyEyse9Mc9eToEH1ULmkRlrQZoZ848a26ovyrEnlPx2JFhMjJsUIyeGGkeLWhHUWrK62PBhlZV7Iq08KncC7lJwQvS779obcTIkyR8mnsaZR8E/+n/sSmtRkumPnjnHJcMe2IDjWg24aYPyzphtf5+QW8Fe3uGEK43w7tEVWJIm9/L/e7TriMNrSUgBuzrDSca2t4MABlQyy4xo8L9G0cjEGMOGiv3WXAv5yuFMAZ/GFXJCUfbbzOaYzxeGiBcpG6ndKYOA3iWXCq5uUulkZ5wowX2lXiqFuP4jn8N8WAuFWleqbrj0dbbLjQH1lbf49hFmg1yNxQ==
X-MS-Exchange-AntiSpam-MessageData: FpkDqePS02039q+YhWDPmTUzql66czdfUrE2FlE7wR81GQLBAGcMbN8/GaTOHhhEXxzKxuDOjPY4OuzVmdROdB5vpPPMW9GOvTgtKp4VhYUm2zvYRjy1HQOyNmp7wAyA/GXh6XTy4T6T786tQYW3CCv7+nNEA8qXQRSeaqHJePEs0ievB45vDJXRHFOwI3aN1cMeb+hAVGP8By+NhVOpzw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912236bb-361a-4602-4e75-08d7d85b925d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2020 05:46:50.8045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4l2/NpnIHbEhMn825f7+rg3gKLWRd20ulkzw/4PVnv1GZZoikKluyw1+YaguHr2s3bCJQ135d4DhdCpc0UX2aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3864
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms020105000104040803040301
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

This appears to originate in Debian

Rationale: https://salsa.debian.org/kernel-team/initramfs-tools/-/merge_r=
equests/9

Interestingly, they claim mmap(/dev/zero) is special-cased? Can we do the=
 same for SGX?

Some allowances were made in https://salsa.debian.org/kernel-team/initram=
fs-tools/-/commit/d6c6eeca3540d18f5bce95b5ffcb1823ab3050ea

Including those people in this conversation.

Ben, Towi: for context, see https://lore.kernel.org/linux-sgx/20200319142=
434.GA11305@linux.intel.com/T/ and https://lore.kernel.org/linux-sgx/2020=
0401084511.GE17325@linux.intel.com/T/

--
Jethro Beekman | Fortanix

On 2020-04-04 05:54, Andy Lutomirski wrote:
>=20
>=20
>> On Apr 3, 2020, at 3:08 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.int=
el.com> wrote:
>>
>> =EF=BB=BFOn Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wro=
te:
>>>> How does smackfs interact with namespaces?
>>>
>>> Smack attributes are global. Aside from privilege issues, namespaces
>>> ignore and are ignored by Smack.
>>
>> Okay.
>>
>> For SGX, I foresee things as:
>>
>> 1. Existing files are global.
>> 2. If a policy of any kind is ever added it needs to be *per container=
*.
>>   I'm not sure whether PID or user namespace is the right choice here,=

>>   but does not matter right now as the feature is not in the queue.
>>
>> To summarize:
>>
>> 1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision=
'
>>   are not "different sames").
>> 2. The files probably will have heterogeneous visibility requirements.=

>>
>> I think based on these premises own file system would be a more decent=

>> choice than populating /dev. Beside, SGX hasn't been a driver for a
>> while.
>>
>> Andy, what do you think of this?
>=20
> Probably okay.  There are two semantic questions you=E2=80=99ll have to=
 address, though:
>=20
> - What happens if you mount sgxfs twice?  Do you get two copies that ca=
n diverge from each other, or do you get two views of the same thing?
>=20
> - Can it be instantiated from outside the root initns?
>=20
> It=E2=80=99s certainly conceptually simpler to stick with device nodes.=
 Why exactly is Ubuntu noexecing /dev?
>=20
>>
>> /Jarkko


--------------ms020105000104040803040301
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MDQwNTQ2NDBaMC8GCSqGSIb3DQEJBDEiBCAiScoid9Ua
Ff8k/GrjBrfppI0+Hei8OCwkO7oA+JyLmDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAft8KIJlyJ/OF7OGaa7aIvcQYnVsaOTFcEbYorADqjsmcE7gggpwIKPWI
keHVbFCaxDDGIGLRjMOSiV+igsCf1hG5SYaSQv9wu+fyg/T9QrIFUmMb4a0PqEETCmLslESO
xDKUz4gkga8QtxtWVfFaSBqWwY88NobBGfAXWw4EQwmUyD8aTrpQPATIPswhN9XtZjvd4iTi
bxnRB9ayqdCTsLnYDmSMG+KhZlqwhDZd/38l4RTKbDMK55FBO8XRNprYImCYDVcUkWYOpYgO
/dIg3du15K4dY2huMfibih9lYqbyHF5819A3seRzunq7WoyoJoBWB2yPp1SiasioG/X5IwAA
AAAAAA==

--------------ms020105000104040803040301--
