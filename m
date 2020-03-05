Return-Path: <SRS0=iPl9=4W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B048C3F2D2
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 18:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A50A208C3
	for <linux-sgx@archiver.kernel.org>; Thu,  5 Mar 2020 18:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="E1sRSg0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCESYb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:24:31 -0500
Received: from mail-co1nam11on2113.outbound.protection.outlook.com ([40.107.220.113]:19937
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725946AbgCESYa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 5 Mar 2020 13:24:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYp6SMck2l6XHnlJKbDVB3Pj0rBUb/IVZA9dtMQxnI3biHW/w4z6j5gV5BGF4tu2V4GoJUESwyex8cBIfKUqCZZmZEs6KosV28HUhkQTLTekCTeiHHFd0e1xnjBUzX/3JniQuOqmIDqLuuX4vcH4f1ZEzNzN7gJwy2Tb2x5E2b2KGjsxKIj1oSPt1B2mXN5TNPbF2GlrZ01weNQRFEGBakcmJ7NROHAZCbk5gRTo7VuEsKytDWCTs2ZqjeGc6lw3KeMpE5IJAHB6mjSH+XsrY4S16MaRfGbXQayjI7nZnWrPLh2GD/lGOLu/3AIRHder33Po8QKQtMgIlNfsQ63j0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eppg20KTfgHZbVRr9lC7U3ImR5/7n3kmPGvKVGZLa/U=;
 b=ibyAVprzfLVr+KU70XPvOGLQjtVMWUksoP9m0qVR3hU7lNk9us0gVNdnymNi9WaQofbyf24MoeLRfdBRNjGFqTBe3HJ4VFKJbGdW9RQUYs/n21161HFk6wgE8hJcILH1KyaPX4iYifuDxlnDAGZrjG9cKSz0UHg3jfEFP9zRRXYTyqukliio4JE1Rxfg2M69TLbwfaqtW9BlV8pvbuxf0IzcOliWtEIvtht/E/W55yEhLazNLOq+EXy5mspDt0vGxZcpW5DkBgsBnO11nc/LBcFK+HFUO3aUy925RIqeypaUyOd37aGZf4L8CK2y+uRpRI5FpGhqruCVFyfloJnQaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eppg20KTfgHZbVRr9lC7U3ImR5/7n3kmPGvKVGZLa/U=;
 b=E1sRSg0X6ItnCvZSUEGqJO+UuMOJjjeCWAo+8nVpvqt7VMJIkCZ7/iNJP0CKggfXdgjOz6pR+pNeZZNXTnNm4mQ/vDUH1/uFHjaHJrsDDAw92GbSzCPDRe0ICSIdqQoj9BGJvOjnse+axVEzshIiSnXf1muwYX5TTW3rWieu0tM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BYAPR11MB2919.namprd11.prod.outlook.com (2603:10b6:a03:8d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 18:24:23 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a%4]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 18:24:23 +0000
Subject: Re: [PATCH v28 11/22] x86/sgx: Linux Enclave Driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-12-jarkko.sakkinen@linux.intel.com>
 <20200305174015.GJ11500@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <e445c2f8-fddd-5740-0e26-a03e023918bf@fortanix.com>
Date:   Thu, 5 Mar 2020 19:24:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200305174015.GJ11500@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070604070802020306060307"
X-ClientProxiedBy: LNXP123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::25) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.226] (212.61.132.179) by LNXP123CA0013.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Thu, 5 Mar 2020 18:24:16 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 040bede7-85c3-4b74-4e8a-08d7c1326dbf
X-MS-TrafficTypeDiagnostic: BYAPR11MB2919:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2919A086042435E01FEE106AAAE20@BYAPR11MB2919.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39830400003)(396003)(136003)(366004)(346002)(199004)(189003)(110136005)(81156014)(81166006)(956004)(4326008)(8936002)(52116002)(31686004)(6486002)(6666004)(33964004)(2616005)(508600001)(54906003)(31696002)(26005)(66946007)(186003)(2906002)(16526019)(7416002)(5660300002)(66556008)(16576012)(316002)(8676002)(53546011)(36756003)(86362001)(66476007)(235185007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2919;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nezen3jYwPDPvAIPqeOF5SifCpODkfz+we0PtlfXpcTu3FHxxCd5NpIkBN0FeRBCv8/0QkyCc8m3yqkl0o4B0PPNC1SsO/zQoqIoW9vcNZUC2QARD1zCmAK3vIKJ6x7M1vB9r0+9PPSyxEIE8zTUyBtcjkup32AAKbgTaTqK5CA6rqqiKG7sM0OZDOigHMgllgz8+hvhFoGNbBWL53lz4wrPPPUF6cRMsOXPCtfKZhmQXNVBfXiNvsg/iJI7DTmaCl+q0H80Xim1tZYcSc9xZoKgwhnXSQAOGF/2U/uPCeYwCazMnsBsZHYhWjXoEhtQcB8dhA999VhIhhntLsUSHti1SWGN9heNrtAP8cXhLVIFIA98FNxB7EnVa1XJOK46ANr23scqyNgIbYwQjYCn/wcyM2FQjoId1Qhum1jIW+owE/BnJxZOHkEVu0mh5JRn
X-MS-Exchange-AntiSpam-MessageData: A4SsgplaVBn/oE9Ru0ssdmMNC6dNQBVTz7uQic6p56OjOnpSBWlftE3TUdBQaj9Hj7MRTz28POprsJ4IVgeZcRehkPHPMVObqmNmc0GjcrtGgqumU6it/KTnd+8JhRGfwJcJuDVwgd4A2RTIEXEviw==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040bede7-85c3-4b74-4e8a-08d7c1326dbf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 18:24:23.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrHpbZ1wankF/Z49R41NdhjJuVzleWEwEVJP0VmLpdp48C6Y8oHOOOC3zN1Qdg6MTa76qmC6mEI/kfGBNWxJnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2919
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070604070802020306060307
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-03-05 18:40, Sean Christopherson wrote:
> On Wed, Mar 04, 2020 at 01:35:58AM +0200, Jarkko Sakkinen wrote:
>> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/a=
sm/sgx.h
>> new file mode 100644
>> index 000000000000..5edb08ab8fd0
>> --- /dev/null
>> +++ b/arch/x86/include/uapi/asm/sgx.h
>> @@ -0,0 +1,66 @@
>> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-sysc=
all-note */
>> +/*
>> + * Copyright(c) 2016-19 Intel Corporation.
>> + */
>> +#ifndef _UAPI_ASM_X86_SGX_H
>> +#define _UAPI_ASM_X86_SGX_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/ioctl.h>
>> +
>> +/**
>> + * enum sgx_epage_flags - page control flags
>> + * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
>> + *			ENCLS[EEXTEND] operations.
>> + */
>> +enum sgx_page_flags {
>> +	SGX_PAGE_MEASURE	=3D 0x01,
>> +};
>> +
>> +#define SGX_MAGIC 0xA4
>> +
>> +#define SGX_IOC_ENCLAVE_CREATE \
>> +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
>> +#define SGX_IOC_ENCLAVE_ADD_PAGES \
>> +	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
>> +#define SGX_IOC_ENCLAVE_INIT \
>> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
>> +
>> +/**
>> + * struct sgx_enclave_create - parameter structure for the
>> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
>> + * @src:	address for the SECS page data
>> + */
>> +struct sgx_enclave_create  {
>> +	__u64	src;
>=20
> Would it make sense to add reserved fields to the structs so that new
> features can be added in a backwards compatible way?  E.g. if we want t=
o
> allow userspace to control the backing store by passing in a file
> descriptor ENCLAVE_CREATE.

Reserving space for future fields is not necessary because the size of th=
e struct is encoded in the ioctl number. The kernel can use this to diffe=
rentiate between different call versions from userspace.

--
Jethro Beekman | Fortanix


--------------ms070604070802020306060307
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMDUxODI0MTFaMC8GCSqGSIb3DQEJBDEiBCCVAwcv1B+N
1o5Gg7KW6mHmOD2F1XL540RgRcHzggIj4DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAM2r/fecuoObSDyo/x1AVp7l3XCN1HtCZdPAZmIoNoAxSkGhAvZ0JSfN3
PKOaDnz8Of3GlXpek2pg9xUhZg0pWVs0icHghyFs+eBfJnHwk6oka4onhpAWzHKPGR5KuJco
zqgu3KrCzzOU2yZ/SXtmR6zS1rGI8UXwZlCkjK3mBz+3RQen9phFfp7LrX/v58wuiY1dTSEV
sfUJHDBMVd8IAtO/gPMG9hz9ZAlOLCI2j+8LAr93RN+d2pSNIXJuKagGb5xkTPTwlG5K6YOd
4r1GOl6NLsgkteVfEnnkUFopO9bAA0S1z8LpeJzxykeSYcVpfj1mA0jguEKRzZ+ZSDYbNwAA
AAAAAA==

--------------ms070604070802020306060307--
