Return-Path: <SRS0=Pssp=4C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E39C2BA83
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Feb 2020 09:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3952D2187F
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Feb 2020 09:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="h2B+SPE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgBNJY1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Feb 2020 04:24:27 -0500
Received: from mail-eopbgr760092.outbound.protection.outlook.com ([40.107.76.92]:4236
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727965AbgBNJY0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 14 Feb 2020 04:24:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8rExINMHNhNUD3V8ql2mVnH4dLQ9BK9Lyux7Dym0ByLZqFrptQmXB+CzuSSvzeiKG2qPw829OzKNRzL7BqffeC8knyHdn/dtH3OjEnbsGIzDcHEa221SuIrcT8TYhM7ozQW7thn8+ZQnNGsjCljAqoAGrUl6DD3Zzk9KV64+U7+Vlg4Igq8/ogoeog4hfDlTMLCrsh0mDV9FFMUrXEIiho8JF4AMo+af6+TmHBTE3U7oDmWBAt/GdgwHr83nV13icHVGzW2Db3r1k9XiuNdfUYWXs5gWdxxGzqCW7q/xQXkynfbDJJ+dGrdV8zWsbkwI4PNoY0giPN22kdBioDpcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmuJzbnxiUde2nvtSQy/ObVDPBqD5h2Kv0Uku5iP1iA=;
 b=gAoHgiHraPRONx7tMqTNzC23KRo9bsiSflVoWChyAxsipMObWP4RiFPW8SOJgKu10dvoLSUuC0KwVdAzrNpdCmAQKyqkWXdlLHomg+aeDUMgMkPtfLOxZXdwiyjhMxLPxdDLIAGQZ2vVsIo5wT6JPxty3skMtVPgppvg2vyiNI0xPs98iRID0euFqxM2pPJA1mlQkgoSC7AJjd2eK6pVjFRmLUEELSoSX1XD6xC6w1FRAQqOmTUJjgvBIuPYkKVYr8Zf4ngc42nZqzoVbajD+jsK1P68nKWrQVVeqAh2riWh1JBCBz/yE4IB8Pbpk8SDqRic7A+nI4lfqirCBc+XFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmuJzbnxiUde2nvtSQy/ObVDPBqD5h2Kv0Uku5iP1iA=;
 b=h2B+SPE8IbGWOpKvXI7zNxFusC2cFxpPzznYUrW51VzmQ4bWUdiOUyW04BAMz7e7ArpuztB10oTrqdsnPCKsevsqvyDkZrUs8LOcDAD/vvvmBeIyrGAu7g4N/cUYp/5h6rRMAliYYtwVxM/i1zTjSbWrfLIMALcjL/wM67GCTxI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB3478.namprd11.prod.outlook.com (20.177.184.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 14 Feb 2020 09:24:20 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 09:24:20 +0000
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com>
 <20200213180737.GC18610@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <a4d9a58d-6984-5894-f6c8-73f2b2b466aa@fortanix.com>
Date:   Fri, 14 Feb 2020 10:24:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200213180737.GC18610@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030508010904050802040003"
X-ClientProxiedBy: LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::30) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Fri, 14 Feb 2020 09:24:14 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45ca3d1-c470-4293-64ac-08d7b12fabb8
X-MS-TrafficTypeDiagnostic: BYAPR11MB3478:
X-Microsoft-Antispam-PRVS: <BYAPR11MB347809DCBD71F9126E2946D9AA150@BYAPR11MB3478.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(39830400003)(396003)(376002)(189003)(199004)(33964004)(81156014)(86362001)(53546011)(81166006)(5660300002)(26005)(4326008)(31686004)(8676002)(186003)(6486002)(235185007)(7416002)(16526019)(31696002)(508600001)(6916009)(54906003)(66946007)(4001150100001)(316002)(52116002)(2616005)(956004)(66476007)(6666004)(2906002)(16576012)(66556008)(8936002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3478;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f3zb6YznkmLr1KJLY+P6E9tRsSOkE4GGGCLbONQ0u35LKcndUDOiGnUOIun0op4qIEjwVk85Bokrz8afIvZI5CUcp4I3GX+OQjAH0uQlzErkex8+H1vUGmpI+Xk6koRJflaTAqMujQRhEibzqtN3HGC+u5726o2+LYE1Sy8EMiZ3P8F5dd++uGA5gxoVmBrBcurhkDdZm00Mbs5hmNHBpZqJ8tFSH4ohrI62YiKklwdGwIRvFBjYczPxrPBK6E4Jy0XB1RTXiP8oQKEjXZTY0sqVHBNkXV/59deAYh/SAPr/RXLkjecvyEgB5Tk4wugh1x88/56/lQO3zSV3JolfS1mN9t/aqfQGLAYwq4vnMRkxrjj/atgymONV9NtMXdX9DgjUonxwVuzcrB0X1xpPTGjxnYu/omDek3QVcoPCWjmeKpzSJfnWJRZRca0CD4Qt
X-MS-Exchange-AntiSpam-MessageData: J1xE/YajytqGa4g3K/3fjsVhojEo5xUQsFdC5B/L7Ug6FPuR1J3imj4f5+368uY8EhK4LSbG3cbBygwvru3vqI6XiCaDlQPMhCSL4d58kErRnjT2DZmCwDMgSkHd/h7bi91ZHHqS100dR2TeAnfZQQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45ca3d1-c470-4293-64ac-08d7b12fabb8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 09:24:20.1970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxJTuKW+ufRnrVChUXdPuvQ6R3OtXEcnSqdb3qeSkHsYhgBnBlbaTD9N8edBBE/rgIXi4QEw4zRhuxltts5UKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3478
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030508010904050802040003
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-02-13 19:07, Sean Christopherson wrote:
> On Thu, Feb 13, 2020 at 02:59:52PM +0100, Jethro Beekman wrote:
>> On 2020-02-09 22:25, Jarkko Sakkinen wrote:
>>> +/**
>>> + * struct sgx_enclave_add_pages - parameter structure for the
>>> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>>> + * @src:	start address for the page data
>>> + * @offset:	starting page offset
>>> + * @length:	length of the data (multiple of the page size)
>>> + * @secinfo:	address for the SECINFO data
>>> + * @flags:	page control flags
>>> + * @count:	number of bytes added (multiple of the page size)
>>> + */
>>> +struct sgx_enclave_add_pages {
>>> +	__u64	src;
>>> +	__u64	offset;
>>> +	__u64	length;
>>> +	__u64	secinfo;
>>> +	__u64	flags;
>>> +	__u64	count;
>>> +};
>>
>> Compared to the last time I looked at the patch set, this API removes =
the
>> ability to measure individual pages chunks. That is not acceptable.
>=20
> Why is it not acceptable?  E.g. what specific use case do you have that=

> _requires_ on measuring partial 4k pages of an enclave?

The use case is someone gives me an enclave and I want to load it. If I d=
on't load it exactly as the enclave author specified, the enclave hash wi=
ll be different, and it won't work.

>> On 2019-10-11 16:37, Sean Christopherson wrote:
>>> Hiding the 256-byte granualarity from userspace is a good idea as it'=
s not
>>> intrinsically tied to the SGX architecture and exists only because of=

>>> latency requirements.
>>
>> What do you mean by "it's not intrinsically tied to the SGX architectu=
re"?
>> This is a fundamental part of the SGX instruction set. This is the
>> instruction definition from the SDM: "EEXTEND=E2=80=94Extend Uninitial=
ized Enclave
>> Measurement by 256 Bytes".
>=20
> SGX fundamentally works at a 4k granularity.  EEXTEND is special cased
> because extending the measurement is a slow operation, i.e. EEXTEND on =
more
> than 256 byte chunks, *with the current implementation*, would exceeded=

> latency requirements, e.g. block interrupts for too long and hose the
> kernel.
>=20
> A future implementation of SGX could change the latency of extending th=
e
> measurement, e.g. a different algorithm that is slower/faster, and so c=
ould
> introduce EEXTEND2 which would work at a different granularity than EEX=
TEND.
>=20
> EEXTEND could have avoided the latency problems via other methods, e.g.=
 by
> being interruptible a la EINIT and/or by being restartable.  But that s=
hip
> has sailed, so to avoid future complication in the kernel's ABI we're
> proposing/advocating supporting only measuring at a 4k granularity.

It doesn't really matter what the reason for the current EEXTEND implemen=
tation is. It's there now in the ISA, it needs to be supported. If EEXTEN=
D2 (or whatever) is added to the ISA, it will likely influence the enclav=
e hash, so userspace would need to specify what instruction is used for m=
easuring anyway.

--
Jethro Beekman | Fortanix


--------------ms030508010904050802040003
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAyMTQwOTI0MTBaMC8GCSqGSIb3DQEJBDEiBCCu/S7ZfGBz
Hy8kmFCJVIL1M408jysgXUYud0+B3yM1BjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAdTMH0yHuBGogD1d7i6EOznZ0gnD19r7ZjhvMMVKuD2l+wcOcPlsu1dsb
/BlNqu5ImX30kjPDrTcP9Oj3CcpnrmsnzQSOFdRQj7OzcMGhQ/ekbmsl1WWfQIK/HB8iHF3A
YIBGVQA/K0QHp5N1eVWCkJpWa/K4vLty7oeujSr5LSBS4yDP/eaErBZH5TDZsMEsPElVMhIB
mWA8p2w5eTIANmUaVm8g3/05GWe103XR+EyXfXaCqzQnt5qejnyTIojd4kynUMKxmJUZ7Iz7
gE9atd0Oac98W+UUQTnz2Z8U0d5bXw25w1uMaLJQTVHBlbyDKO1mOvRkuLM43mAjs/EeBAAA
AAAAAA==

--------------ms030508010904050802040003--
