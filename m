Return-Path: <SRS0=pIwf=6N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D17C83004
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 15:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25F8320775
	for <linux-sgx@archiver.kernel.org>; Wed, 29 Apr 2020 15:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="MphuDOK3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2Pai (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:30:38 -0400
Received: from mail-dm6nam10on2114.outbound.protection.outlook.com ([40.107.93.114]:56416
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbgD2Pai (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 11:30:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2284nplzXDQIPYe5sST86nneid72L+CpG2lhvCGuRLI200qRkzOdPtsiBqKrJj3WGokDhIfGxLYotMx4nSqjJ1ePzm0eS5vGChrLcIMDEuIoAJZkjKZl1qJY94MPBqvismVKcKDvC1BVas26EtVN8+DxnZ0ulgA8sd5+/uqji9vbfYK/YJgbFasmWDeVebaP3myNzJaH/9/xG+AO2/jEonBZL13F6wM+RUDxnGNpw36pEF9sSTYX38N/U3tgwiRGfDiqfZG/kz9JhXz9Ye8otJCdutJU1rqtSoOwhy+B548b89Tg2O/AG8f5fPqOvJ8OwkJDBFgbQFSL1X0MIJo+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmxBL/J7PagucYDLBUlyOx7Xp8AmeYPCel9RJBL0RaA=;
 b=PaDvTHDL2EAyiS64Wfa5USZB0dWboGmxyZYUQtPQ834pqJNZFisYIgn5eE3wLHIfrBHmVUxk/E0CIBhkc170hbblwH4tEvoVomRmk4i+hp9NfDRm8xdLZ2+frKvv2Hz9oEWDhisvgLYt6HTlgopx75TOgixBLwqpRqd45LtbBcMx/Eiu+HR+feAht6dyFb2z/+fmPuUoCFignNROO8le67FJe1B8KJZxf5BlGhmXcJRRi3Ial5eyMWhJC+0zApSXThBa+K/SEQxZcUFezgANc8QH+Z9IxtXeOMhP0Kz7NE+J+JTlPWxA+vIqzIH4ELcRKkpWZ5wqkhYnLrfYS7me6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PmxBL/J7PagucYDLBUlyOx7Xp8AmeYPCel9RJBL0RaA=;
 b=MphuDOK3lXu9+RsAOFK08Dc6dR5v4N8KdQ7go1DFbm2LBwXAju5c7N2feE4VGoZ3wDN+u07pYi/8VHWPi/tRbS5fXU1fvlvinHd3ee/rsPZnRlLUrQzB2tmsLmYxYJ2ASFUJJ1NwtiQa438p99AqYHwYXOD0HCGfcsqjB4swIeo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB3959.namprd11.prod.outlook.com (2603:10b6:a03:187::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 15:27:58 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::48d6:af47:b6c8:fe6a%7]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 15:27:58 +0000
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
Date:   Wed, 29 Apr 2020 17:27:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000605070402020109060108"
X-ClientProxiedBy: AM0PR01CA0094.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::35) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.61.179) by AM0PR01CA0094.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 15:27:52 +0000
X-Originating-IP: [213.127.61.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 063ada9e-4787-48e9-228e-08d7ec51e512
X-MS-TrafficTypeDiagnostic: BY5PR11MB3959:
X-Microsoft-Antispam-PRVS: <BY5PR11MB3959492F16832530FA928DA9AAAD0@BY5PR11MB3959.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39830400003)(346002)(376002)(136003)(5660300002)(66556008)(66476007)(36756003)(235185007)(86362001)(956004)(66946007)(2616005)(31696002)(31686004)(6666004)(33964004)(26005)(16576012)(52116002)(53546011)(508600001)(186003)(6486002)(316002)(7416002)(8676002)(8936002)(4326008)(2906002)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nnu+6uwe9ptuEI0scM5f3Sy2WN1ybMgvPrakS5+LOFXwLTrxf03yT8/mQpyGYw1UTMJEJeIcxQOWOvRlH8lJAoyxOMV4ch09l0aDe3ILVb+kY/kZt3gCDFzAhWRDXwXKSJW+ncLItaiv/0bdjx2AzXvy7ir9876EdTvRekX1GQXC4+Z5ziP/MU5tf+e3dVt/pIJxdGXozPoNpwdHPyhg9V56cfbI6F2Ds8r5xEnOE2GQdfFEHTRg7hOaf0lbnsM9GWMl/sT871zPGfwL/FkN/zfJ/tWDuCWkD/hTlre5DKfNTsT227FVOWFTUdQsvP36Fc0MN++AH1JnHL4nrnXplRFTzWSR78mQBlKDUuJiZfdlkNKN0TzDtUlxHbthM4tww/2uHrJ3gc00UZY4RUjwwf3t4r129A18Uny41XaylILUlpg/VLcVx/WLjZRF28x+
X-MS-Exchange-AntiSpam-MessageData: HXTb95sibXBFjhU1JoBOgzjcE8Vvcpj3frOZ/3tJxhFXKOF+jxC9uIIAtT1gsWQPwLBOs5uxJE6tvrPmhIoQEw7Ez4xeg/PrucXCx4m5uK7gy+640cqKw29xgHaiNXXkOlSKWWyFZMuH6pz39Bo24cAeOileumUwzBoGDf6ZERZZQmBE1AceOwurwR8E9fY8DeEQgmOmcm9L31ykO5Qlpi9CFAIDWAqRxLjoN3tuqUEDQBSspiT71N9MkpuTU99ne9qTsBtRXFpqPl4Juu3B4klfl2urnLa7uEXyLTv0zxbYHB7NUQk1mfckrS7LTpFm3d9AcyF5ArK6RGbKXEPeVPBH79Q6IvL0Qbi6J3i6dIq0v75tHeNqhr32skWVpNKPZcL7MoW28m3vSill6TIQRy7K5PnMATBXOHidgJDtcF5z92Paif/zNMFFpJ4dqu4wHjL9z025PkbCkMAg43AFHntU3wFqnGMwfVgBRDRqZR8nlI1qRiJoFz8/4My7mPnEGeHjIFJNzgQ43cIYWC0O8kmAvg0phmsttse5zKwDQnbkWujJ3aBLi84Q4k6hjt5KRFKT9/9H+/ky1tRZgu0OFm0qfqSguhTnHeM02sUw5GoQyVfHY7EErPrUH9yIf9ISPhraxubznwtsRGI/NOxIxTctLDqA+pKduxsbT7nHbWSOMCwj6xbEhS+rLQMirOTG12WuqUeWzEF6LEd7olY6bPRO+jn8DMIWUdLyYXsLNqYu+WjFO+uzysaX41Uistq6As1NiFbyO9KtPyKrf4ERH+b9eGeFlvhirOu+qtmNSLs=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063ada9e-4787-48e9-228e-08d7ec51e512
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 15:27:58.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N26buKJZuKsFzRXS8z7paATPLEHfBO74TpEY5q6SouBQuPO5GfsWuMDOjcvyfy0KQj2vi6k97L8uzlNJTkfJ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3959
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms000605070402020109060108
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-04-21 23:52, Jarkko Sakkinen wrote:
> Intel(R) SGX is a set of CPU instructions that can be used by applicati=
ons
> to set aside private regions of code and data. The code outside the enc=
lave
> is disallowed to access the memory inside the enclave by the CPU access=

> control.
>=20
> There is a new hardware unit in the processor called Memory Encryption
> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can defi=
ne
> one or many MEE regions that can hold enclave data by configuring them =
with
> PRMRR registers.
>=20
> The MEE automatically encrypts the data leaving the processor package t=
o
> the MEE regions. The data is encrypted using a random key whose life-ti=
me
> is exactly one power cycle.
>=20
> The current implementation requires that the firmware sets
> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel ca=
n
> decide what enclaves it wants run. The implementation does not create
> any bottlenecks to support read-only MSRs later on.
>=20
> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
>=20
> 	cat /proc/cpuinfo  | grep sgx

Let's merge this.

--
Jethro Beekman | Fortanix


--------------ms000605070402020109060108
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA0MjkxNTI3NDhaMC8GCSqGSIb3DQEJBDEiBCDHMp5HLb7G
wssb2UkpsevCnHUBV2XSBaMg/SPDZssHLjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAxCaYEQHMi4rEIKU/y7B9diRj654Dvi7WY6HEOPJ2scC4AV/eOgDDKz/b
Qb7jcveuwhnpRfHiJndpb/3HOkpozY9cBqAp6sCBJ3SJJ++PYygeH1p2cIa2RPBN7iAt+l1O
iS4WEwwwwcalGLr/78zfgDsPXEKI7yHOP+z2GViymriCqFP2J7MptKdhUDoJSJXShvmavig/
8xRuO/6w0ttpL4FQyhQ5F+QZmlSjMXDwqPuHhF+gdEB245gzh5FUIf0T88lZYZGxeZu1cL8u
5H1H6+LrTrCAnXnCPspDji05+1DG8EVy6F26dWDdwhtLc7gaG48gJ7wEBcAPlxElwTWqDAAA
AAAAAA==

--------------ms000605070402020109060108--
