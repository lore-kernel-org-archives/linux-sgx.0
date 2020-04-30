Return-Path: <SRS0=MviC=6O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,URIBL_DBL_ABUSE_PHISH,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68077C47253
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6582076D
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 14:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="gebm1nwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgD3OMZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:12:25 -0400
Received: from mail-bn7nam10on2120.outbound.protection.outlook.com ([40.107.92.120]:23489
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727921AbgD3OMU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 Apr 2020 10:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCBPH0fxyqm/1TSbxyGsR9Eyj3SvoWvHKreaG7yc8M23/s7B6YLaL9QIUDdzX8kgJzFe0LW47TLXKJpwrnbbg4N6iD4HMWR0YLkULrJh6lW0I7WmbmW28Ga7jUl1457H/xF0fKwmQnwFidDKurSJNA95FzryRVreWmDgxMjE93IM2WshuSPydYrgHVXDzKB+LPCnjzAWZFscgA5rUxpqSs7J7rQAXIm8qctpnC6qhExsQew3OjxcGe3AbdH4eHuuqT3mfpvbsJZ2ioa5mDmWTT+6JLcA3uTwPEkrUDjVn4N4YRRlrDe4hokTxXykUeEpLJNHQqbMOOeQG6Qn2sSi5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3NSqFrNGTBiDn2Kk/DqYBBbQJmRjJLNTHEzFlstFWg=;
 b=cgJQtl+i4bogD3KgGdQo5PA2wGz2tYZYIb2VbskZqpVhLUZi5dBIyWVzzRCpwZa6WEWy8MpPGnSt/Z4rLgKPeTv8gdseBPA9t1ss8fZdwAcVXQQCtQ9SPicqyiuFzjedBLsr3AMMPjEfptygLNHED7ZiwGa1ENktY4zwuCDy/6CLzEOBpK1D8AxkPo9pGFuTNha+K22rAV/39O61+Q0qiAUOcfWZHCqn6A8hViWrXNqo5GCKuGkjC/LLQ2zwP50+w4Hyot5dxxDRD6qLTymCr/VvASOMswMSScUzHgGlwbttVZ4dG8zL1skOV3QFOx6QQ+7PJ0B3qcGcdYuAvfGKbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3NSqFrNGTBiDn2Kk/DqYBBbQJmRjJLNTHEzFlstFWg=;
 b=gebm1nwmLzINrATqgP416KWuUNUcn3vo8LF5GzXXoRCyOK11/A3jGssbtCgbpUUxHYt0gVoRIs7yzPIHbyGci3VyACErcZAVjxjWXOy5fjTfBuEf0Z7HJaLGqFG1jZK7YV/7e7aLq3kAaruRYSRQJDyONXV24+NJzo0A50cZ4lI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4484.namprd11.prod.outlook.com (2603:10b6:a03:1c3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 14:12:16 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 14:12:16 +0000
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
 <20200430034651.GB31820@linux.intel.com>
 <a9ff7817-32d1-e048-af05-862ca9f8aa46@fortanix.com>
 <20200430082328.GA6387@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <1dd3ba07-f782-3a82-ac25-83d524a2c062@fortanix.com>
Date:   Thu, 30 Apr 2020 16:12:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200430082328.GA6387@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000700060400030209000802"
X-ClientProxiedBy: AM6PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::36) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.61.179) by AM6PR10CA0023.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 14:12:12 +0000
X-Originating-IP: [213.127.61.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6f9021f-bceb-4194-c395-08d7ed107c3d
X-MS-TrafficTypeDiagnostic: BY5PR11MB4484:
X-Microsoft-Antispam-PRVS: <BY5PR11MB4484EED3FDD543685D4D842BAAAA0@BY5PR11MB4484.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(346002)(396003)(39840400004)(6916009)(235185007)(5660300002)(2906002)(7416002)(2616005)(956004)(508600001)(52116002)(86362001)(53546011)(31696002)(4326008)(6486002)(66946007)(33964004)(31686004)(66476007)(316002)(66556008)(8936002)(16526019)(26005)(8676002)(186003)(16576012)(6666004)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OypMjUcREdlxOCeGIv91/bLAYnb3NFl5je/2m2qwnzdIj1xSLmSqMddn8ekX2Ofs6M5xHt87ULqFnsWghJIQjTzaDdHF9JQtMgRSyDdUiGiFBMpnJAGfI/vK1Kqok3SGDsOX4Uo+Scl2cthgmDcA89ixsjuiwrL9wUgXTbDVhPAX/krRUhNBQnOvJ1CZS62/rj8UzbLrE2CkqprP/EkeQO5/70Tytvx6za0Ne0KhG9wf64McMP4GwD1sqCSGuGin/nZ/CSXXaSOi6iV2DsDcAMtPzVE5CJya2CB5dndOZxfU1KNCman+RpC7w9BEMNaM4qc3K86ekSCeo6z2EpqMieAKNTLyeCAAFyB7opwiTBUhLuL55Ohgj448NRyzgbtsDugXUWMVNZdTcBc1nG6dYPHRWJSySno4lLw/FKH+2ZsJSThDbCFzZD81qWb6fsfm
X-MS-Exchange-AntiSpam-MessageData: Y+7zUk4AK8dR+L66FXsR/jC8vKH+fIGUxXesMIPH455PSMYOucEO/h7BNpQ5gHypSy7ZPg3lpOuPojFBEgTMXmUtiJYeP4Rc5lC4tD4rknhymzzIqsDX7tV6n/zOnnh5l+zXD2leH37LgSIhjOEQbq14MF7J5OBwEP9P+x1DbIB60lB1JxPPskEcEmTOjhtyXrxxvt6xxxWjgogpX197RBm90MjwlKl3qPWH07rCK2DLhIFFQzHRUOP6qk4grZTwB7TMwL2mpztxIRwu6d9fOPOlftZITd29dkV2rPc9fIKKJzuyu0mELtE4jMLqRvYJocD1kIsvX+AXtDzMyao8cR0qds0993neVWtPcEmqMKQtg7Mo28JZXFbku+GRWZno5nAwm34oX2ypRKppuJ/xNTCr6VbzHqAdbOkIP2ihpvfzk5GTASouvOuG2wKsXmINXWad94N/5SFziW6LxkdOIpJDqBemSEX8Y9GN6gnolbKlIKjcyxOgkBwnWefhZYGEfJt8grK5DKTIARxdWrRzN0Qh5g7DesalSDUVY2bjzf4JctlfVsV5rish78xvBPdaMmtiB/ZwPoncsFS+6JxN4vlcfWGV4HO1zTRt2xqLFPUZ+udQnphUUSlzMMFhEMc3Nn3zrDUWQ3KLF3LTIE+1bXhsfNfAcsLhw7n4UTyBZ0rNVrTmszWoKW52KI5em0VIXHKQffHqxw0koqUXb9nPP/mJvaomMnDsLJo8vtQdoxoW4QzecNIYpbaeeqodnNtFt7cU/UpLcsUNHaF3wZDfyM5knhorERX3xAW/Crtd7cU=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f9021f-bceb-4194-c395-08d7ed107c3d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 14:12:15.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFp6avzGckYP5S2K58I520KA7QDfG/exHr3hZoXuEwm/xR6JmAnS8OnAazBzPDYdUKmtIdUK87ztP4cpHazodA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4484
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000700060400030209000802
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-30 10:23, Jarkko Sakkinen wrote:
> On Thu, Apr 30, 2020 at 09:19:48AM +0200, Jethro Beekman wrote:
>> On 2020-04-30 05:46, Jarkko Sakkinen wrote:
>>> On Wed, Apr 29, 2020 at 05:27:48PM +0200, Jethro Beekman wrote:
>>>> On 2020-04-21 23:52, Jarkko Sakkinen wrote:
>>>>> Intel(R) SGX is a set of CPU instructions that can be used by appli=
cations
>>>>> to set aside private regions of code and data. The code outside the=
 enclave
>>>>> is disallowed to access the memory inside the enclave by the CPU ac=
cess
>>>>> control.
>>>>>
>>>>> There is a new hardware unit in the processor called Memory Encrypt=
ion
>>>>> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can =
define
>>>>> one or many MEE regions that can hold enclave data by configuring t=
hem with
>>>>> PRMRR registers.
>>>>>
>>>>> The MEE automatically encrypts the data leaving the processor packa=
ge to
>>>>> the MEE regions. The data is encrypted using a random key whose lif=
e-time
>>>>> is exactly one power cycle.
>>>>>
>>>>> The current implementation requires that the firmware sets
>>>>> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kerne=
l can
>>>>> decide what enclaves it wants run. The implementation does not crea=
te
>>>>> any bottlenecks to support read-only MSRs later on.
>>>>>
>>>>> You can tell if your CPU supports SGX by looking into /proc/cpuinfo=
:
>>>>>
>>>>> 	cat /proc/cpuinfo  | grep sgx
>>>>
>>>> Let's merge this.
>>>
>>> So can I tag reviewed-by's?
>>>
>>
>> No, but you already have my tested-by's.
>>
>> If it helps I can try to review some patches, but 1) I know nothing
>> about kernel coding guidelines and best practices and 2) I know little=

>> about most kernel internals, so I won't be able to review every patch.=

>=20
> Ackd-by *acknowledges* that the patches work for you. I think that woul=
d
> be then the correct choice for the driver patch and patches before that=
=2E
>=20
> Lets go with that if that is cool for you of course.
>=20
> Did you run the selftest only or possibly also some internal Fortanix
> tests?
>=20

v29 patches 2 through 18:

Acked-by: Jethro Beekman <jethro@fortanix.com>

I only ran production SGX software. I didn't run the self test.

--
Jethro Beekman | Fortanix


--------------ms000700060400030209000802
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MzAxNDEyMDdaMC8GCSqGSIb3DQEJBDEiBCC8+noYmP8z
VjmGEfKKsGlrsZoBPd2xu3WtbTh3o7CN1zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAJJeuIjH1OSWEhT9hduPkZigYjkkrOHRMdnTystc1ebVKR6Dtyaunh7oD
sYIRRzSKhuzLlNGa7b42PsINKtB6ZjTTgIaLCLuQh4Xot3niiAA526G8DTn3QEn9gkx8nO/l
zoVkNTF3FzZagMP5HciMMLCGAbqGeHGWXyxri5nftMt4OwHI0UG3FhHpwPoNFqUR1C8ZBJeA
qLbswI09SnkyJaP61bCNbcBnMF2x7LI5zyQGMM+tx1YpllMRnzBqPD0jeZvgByZEvcy45lNj
BUr0lBqO/xP01Z89tRjJ4bfQl/AyfQUfbJYmNVglH6YOUww9FL1O9d22qnRSlcFfS+P1SQAA
AAAAAA==

--------------ms000700060400030209000802--
