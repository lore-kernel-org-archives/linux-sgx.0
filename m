Return-Path: <SRS0=OjbW=4B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3055C2BA83
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 14:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD62218AC
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 14:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="J4rFTg+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgBMOKi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:10:38 -0500
Received: from mail-dm6nam11on2111.outbound.protection.outlook.com ([40.107.223.111]:38941
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730132AbgBMOKh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Feb 2020 09:10:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvHiEL9ZpNNIkNla0uokdoYv9Q7sRTXwtQk1HwxpWF/x7bI7+Ct4XguIiYb6ZSt3cyFX1idTncTe/UYZjxq46jhNaj91o+37EFB1iXawZLKmcmGQ5PdqAKT3XclGcqyk1EkXKsN+G+270gmxvtxstexCWSougmw1Y75LcxJ2mISwx7rMlzCu2jvCr81WbA8LVeXPPGALheawewZ5Rnvy9jv01FvMtO4O9ItBdLkmASbxuKvD6gBepf/1AyHiPUVYtLxCCcdTcfmV0ra98YfasrDU3b3E+zpdkOVrN8cC7A/Dw9HXrOu1ArBs521d5f7AE9p0sXUaHXEovHTgh2nmeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUeqSbryb/NHjVuh59QPA63cBJ2V9vul1Tw+P9fOFho=;
 b=JkD+UOY14ws9d0AqIPpZfd7ablA4aMf/bSfh1+y5FZwZ0LMgMHOR05FPH9zUOrQuKYS9jAlKRIPq34uNLJNzs3wYB3USFOXcGLC2wHw2NeJq2/DeOnpZmr9wQopnaAfjwo1ShhUhLsHsCF6fkOfQ8AvNvm0XRQQ8/fY8uBsmGc8qYFp4FwZZPcQygLBzHlv/voL/JFeDLDpHLYzkqAN99eaVurr8VTbh7u62zUzRAjQU/vVdk6WP8b8cRa2SncpcUQ1uOhACSRuu8dL8qnd2V9r5dBSXMvOjERlRsAqyqGRevKc+BRcnmGhyopdb2sNMlnG5zdV6+OdB7iREfQkyAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUeqSbryb/NHjVuh59QPA63cBJ2V9vul1Tw+P9fOFho=;
 b=J4rFTg+5mjHGUPWGzQ0QojzbPfNGxf6CmFGdcIIsQYsf84Hn1cgZFxFIJuhEEltLtK2h3q9UMJKmCT/VXvTV/ZsqHg5/91163mdqUAYmh8A8NJWd1KTD+3Re0ygfgyKfQNNY5u2D3OvR/sIYW7RIpoieaECHwVgtqPbhBSBszwk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB3494.namprd11.prod.outlook.com (20.177.225.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Thu, 13 Feb 2020 14:10:31 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 14:10:31 +0000
Subject: Re: x86/sgx: v23-rc2
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
 <20191011181550.GB30935@linux.intel.com>
 <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
 <20191017175735.GD20903@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
Date:   Thu, 13 Feb 2020 15:10:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20191017175735.GD20903@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000302090304050709060708"
X-ClientProxiedBy: LO2P265CA0061.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::25) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0061.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:60::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Thu, 13 Feb 2020 14:10:29 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b8a6f0-42ac-4fd5-b720-08d7b08e7be8
X-MS-TrafficTypeDiagnostic: BYAPR11MB3494:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3494E168EB68FDCA60E104F2AA1A0@BYAPR11MB3494.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39830400003)(396003)(136003)(366004)(346002)(199004)(189003)(54906003)(8676002)(81166006)(81156014)(508600001)(2906002)(6666004)(31686004)(8936002)(36756003)(4001150100001)(31696002)(52116002)(86362001)(33964004)(4326008)(53546011)(66946007)(66476007)(66556008)(6916009)(6486002)(5660300002)(316002)(235185007)(26005)(186003)(16526019)(956004)(2616005)(16576012);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3494;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4LlBK839qNf7hfkeAgsluwr3iyU4HfKJNOHiqeHrf38T6D7MF1GvUCAc2sv4f5xWhrNy0vN+YdOCsHLeNaRaS/6mkfEv3PLomeUd8H8XKakYKbrxIu2bo3mvlL3KOUPxrjaRo22icULC/Wb+m52A4xV2xHu52IlKT2JWZpyQH18ImM/TexdT6AjfpnIuhJF4Tro8Gb7ESwR+8ZVnussW6P3SPDPJPBHFk8EEBfTkh7xKim2UYX3+dZxDjWAgu9YN+JasQBluR5LLcLHYcP6C5D1AUcritFTTnCPkbVvB63RqAyPaRxhuhGRbhy/6fTwqAD2DOkchBk1SVPRYpG8J3Ci6+fn1t+Dov56zV0QXqs13Vs2ETAj4emSrdt4YIKdVn0Ia6schuB626QKetIUt6GK4fDxWwC/M/q3QOeSqzqL6CyYjIYdJLFdrYNxv3Rc
X-MS-Exchange-AntiSpam-MessageData: TJKUBI90sJLFXcgpRH+JiFo6BGSoepSdIk/0MvDBcjh/+4nsHVatmOBUzfk1ykrzKsrH92eobS+CAsxkCpcMCXqL+GhRL8H9lflRHW8n5nUI+ko0mWQNMBYIMW8bhELKI9wsUEVqjNQeorCmcVoRkQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b8a6f0-42ac-4fd5-b720-08d7b08e7be8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 14:10:31.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDGqTSCnjLhTDNHY5JAuS8W5Oqdi0rFUB/IOGHN23GwfLRn8pi9EHKDuWuhFqYXWNj/qsKA33FXXytUHTexWBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3494
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000302090304050709060708
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-10-17 19:57, Sean Christopherson wrote:
> +Cc Andy
>=20
> On Mon, Oct 14, 2019 at 08:43:09AM +0000, Jethro Beekman wrote:
>> On 2019-10-11 20:15, Sean Christopherson wrote:
>>> On Fri, Oct 11, 2019 at 04:37:25PM +0000, Jethro Beekman wrote:
>>>> UAPI:
>>>>
>>>> This got a whole lot more complex for userspace compared to the out-=
of-tree
>>>> driver.
>>>>
>>>> 1. Manually needing to mmap a naturally-aligned memory region by all=
ocating
>>>> too much memory and then unmapping parts is quite annoying. Why was =
the
>>>> auto-aligning removed? I think this will need to be handled the same=
 for
>>>> every consumer of SGX, so I don't see why this is not handled in the=
 kernel.
>>>> It never seems wrong to align if NULL is passed as the requested add=
ress.
>>>> Alternatively, is there room in the flags for a MAP_ALIGNED bit?
>>>
>>> I'm pretty sure everyone agrees it's annoying.  The short of it is th=
at
>>> the SGX driver is the wrong place to do the alignment.  The driver co=
uld
>>> key off addr=3D0, but we don't want to take on that implicit behavior=
=2E
>>
>> Why not?
>=20
> Because it's a hack.  If a MAP_ALIGNED flag is added then SGX is stuck
> with kludgy code that serves no purpose.  And userspace needs to manual=
ly
> align the result if it provides an actual hint.  Regardless of whether
> there are use cases for providing a hint for ELRANGE, having divergent
> logic is ugly.
>=20
>>> A MAP_ALIGNED flag to have the allocation be naturally aligned is the=

>>> ideal solution.  It's definitely something we should pursue, but that=
 can
>>> and probably should be done in parallel to the SGX series.
>>>
>>>> 2. Having to re-open the device for every enclave is also annoying. =
This
>>>> means you need a filesystem available throughout the process lifetim=
e. I
>>>> tried dup, but that doesn't work. Can we make dup work?
>>>
>>> The semantics of dup() won't get you what want, as dup() just creates=
 a
>>> new descriptor pointing at the same file.
>>>
>>> An alternative solution that was proposed was to have an ioctl() for
>>> creating an enclave.  But that means using an anonymous inode, which =
runs
>>> afoul of SELinux permissions, e.g. every _process_ that runs enclaves=

>>> would require EXECMEM.  Linus was quite clear that SGX wouldn't be me=
rged
>>> if using it required users to degrade existing security.
>>
>> It's ok if it's the same inode, it just needs to be a different struct=
 file.
>>
>>> I'm open to other ideas.  I wasn't aware this was a pain point and fi=
le
>>> stuff isn't exactly my area of expertise, so I haven't put much/any
>>> thought into alternatives.
>>
>> The default permissions for /dev/sgx/enclave are root-only. This means=
 you
>> want to be able to do the same thing as network servers: initialize so=
me
>> resources as root, then drop privileges. This used to mean opening /de=
v/sgx
>> and keeping the fd around which meant you could launch enclaves at wil=
l. With
>> the new API, this is no longer possible, you can only launch one encla=
ve per
>> fd. Is there a different type of operation that doesn't just duplicate=
 the fd
>> but also the struct file? If not, can we add an ioctl for that?
>=20
> My approach to this would be to chown /dev/sgx/enclave so that it's own=
ed
> by root but accessible to users belonging to an sgx-specific group, e.g=
=2E
> via a udev rule.
>=20
>> There are other scenarios where it's not just the permissions on
>> /dev/sgx/enclave that are the problem but using the filesystem in gene=
ral
>> that is. Maybe you've used seccomp to disable file operations, etc.
>=20
> Andy and Jarkko, thoughts?

Folks, any more thoughts on how to resolve the issue that you need to cal=
l open() for every enclave?

--
Jethro Beekman | Fortanix


--------------ms000302090304050709060708
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAyMTMxNDEwMjRaMC8GCSqGSIb3DQEJBDEiBCCfPeA5Zh8S
Lz8wzH+LEqDirPhO/7cUVmLioR2fyqW/8DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAiEzJYyA0B2qM08iZIZXg7DtwohgOS1OBb20IbE6gwiNmK3puFKSLKZxz
36Qyn3sVj1O3ruJTCIHdTSTy/vXwWn6Koj1wjJs2ZsdTPmuyQzUXTxbFAfdHofQWSN/DmHp8
q1bnBnwCE0Rcp3c/Qqp5GmWadvMzCbXL+LPVn9VtLSLNsYJrzX7qHku/ItS3ATJEZwNVh+8M
e1r9p31g5/OZmjKY5SXeJ06ejvOFbhqt09mGCxw34J2xwPRpsg9qnUImZh4fKhSdgzUQChXq
4XbCbSsmck68zHOBkRHhy99hbcl60XvpBWQfBaGvrk0xk2/3tNfP9xvjq6n5nyK+/xZ6WQAA
AAAAAA==

--------------ms000302090304050709060708--
