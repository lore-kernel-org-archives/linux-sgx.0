Return-Path: <SRS0=Aco+=EO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D525CC388F9
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B5C5206ED
	for <linux-sgx@archiver.kernel.org>; Sun,  8 Nov 2020 20:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="bFmrPBvp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgKHUse (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 8 Nov 2020 15:48:34 -0500
Received: from mail-eopbgr750129.outbound.protection.outlook.com ([40.107.75.129]:34572
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727570AbgKHUse (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 8 Nov 2020 15:48:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY6THCwvDjoSMEGxXRZlz2Uwl+VCFFM0h8uFgMiRB7QILwpNzavqCNEmCWYMZYip9kvN50lPB0sCJwGJ4PaZn6F9yTCs96QOItYsCOAXohiWAyhOZlQhm2LObdKuSPDJFOdB4s4QbaWr8S/2yOovDcdTMVlP7KtK6Rh1zotj0HG2J+XL2xP8spl42FZex2nxGlf2eWmUONtSH7tH+0nEw5Gkf1nfVkyJyt1iCZKr+7JkxRL2WKTIoh1DMcYVwFuLbAems1GwAnCdoeSRf/0WdgJy6LVWpDhjPdewZ3wwk8SBwbAKkdXRarmelP+bqaQhq8wkX+lu16GzVT32uXXxFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fitrhg7GE5/KGT0/jczTedENE6OKvvqP/w6VkPgfeyQ=;
 b=cK4KKoGD9Nu8HsB88kuIGTtk8xLaFC2nGCtvejq6+Fyupd7PjNN8bo0ovyhgpXMsiK08h8PT4ik2YuR8EybS1wncuYxGFZh7eKs2ChD63fUxTARzF3ZYWVnZxBTstRoUQb+s+wSTm9iM2Tza0aOomdSBawbJUIFSolq2rsKiKkzSrONMLXCgkKRo8dv8rDq3CLSQ8S/Vg1ghOXD2GnaNtC0iQVikI+YhfAaTstTkGH5iOuu+vazWUt7dMl6DDL+PXqk0EA08667CuYgDoO9+Ig10Oy3KDAlxwpbucGA7xV2EUrHNGnaZvFuURbJzU46l2si4rEODbNFLrVwZQeAZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fitrhg7GE5/KGT0/jczTedENE6OKvvqP/w6VkPgfeyQ=;
 b=bFmrPBvpzl44OEAdWua5H1K92KeNcf5g6kzTcrZhsU9+f82vWIB35wqzWZ+P6PhPNiO9KtGCTVgaOhPXRSj5a0tOptz/sLmhAtuC7GVk0NUG3qN8a6WFgbMTXa94qa4nYKckoypc6DLmNAHjNbn2BHUA8q6U5NcKt7nWgeSUSqA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from CH2PR11MB4262.namprd11.prod.outlook.com (2603:10b6:610:42::13)
 by CH2PR11MB4405.namprd11.prod.outlook.com (2603:10b6:610:49::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Sun, 8 Nov
 2020 20:48:29 +0000
Received: from CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706]) by CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::c4d:afdf:4dfe:2706%4]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 20:48:29 +0000
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <71581ea8-2b97-ef74-d935-476ec9c9cad0@fortanix.com>
Date:   Sun, 8 Nov 2020 21:48:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030103030305000103010301"
X-Originating-IP: [213.127.125.17]
X-ClientProxiedBy: AM0PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::18) To CH2PR11MB4262.namprd11.prod.outlook.com
 (2603:10b6:610:42::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.125.17) by AM0PR10CA0008.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 20:48:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f2cebff-bf5f-4a93-b953-08d88427a578
X-MS-TrafficTypeDiagnostic: CH2PR11MB4405:
X-Microsoft-Antispam-PRVS: <CH2PR11MB44056A9A418C13C30F653C49AAEB0@CH2PR11MB4405.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wPKSMpUMTGUAo9w/wGUl9im2GoKrS8JlkRg1IH3AUXvKiDgVq/sJIS9Mvq7ndJcCRSU2PseEABhoGXI20msImq2dVclogm16wjWA3UhxXZHBiqoOQqtRSj8jdMFKsHbOuEEAcqZA7FCxXSj3+nRnVSHwus/c4hq3M+g8wYSk28Jp4tYnVpznPjZPc/e/qPDC7myx9W/3FNpUlXpKCuwQk/xabyQVp1hy3KOlkOqpfGq+iQW8lLaUqosvtCemNW1lm3mNaAFtYhHO7dWI2+N9nJuklac3MZ2t1Imk+wLzexrplQmEcYDhGaSzfp4ab47pRo8eVP+f4lnLIk5tGTkNB38Xbvp7c7wwW8EdrVyYQU5mXxpiuxWA9XnAZK/juKl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR11MB4262.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(136003)(376002)(366004)(396003)(16576012)(31696002)(316002)(52116002)(33964004)(6486002)(8936002)(8676002)(6666004)(956004)(2616005)(5660300002)(66556008)(7416002)(235185007)(66946007)(66476007)(83380400001)(53546011)(86362001)(4326008)(478600001)(186003)(31686004)(16526019)(36756003)(2906002)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zjUefnPLQAZilLsQTUNQ6w4mbU2FdgPDaY2YDUstv9UUGPEebZ91U4JJ+SczpNNrU8z6kHzTSPfWRVDvbqMpHLRd3hFZJc0oIXo6CWoVX2WGhNlaBRqe/B1sqWxw87m0tK6PDZ3V6ozFw9DaRo7d3ty0oXE6b8XCgV0dgV6nKvnPL5qUlAYmo7lG9+Jj19ShLsOgYUo8ODOdEcYX0D5OCP9B6ZG+0oWFxjtMC28oZNzoX72F+KzGjhLWEHZZhOtPsoYTRgbyRztAQ9JmQ1dIroT9YVGgbcQdoFZ9vffhEJ0O/6ZYJlGu46qOLIkhqe9YdmxoKAqZ2BZRWcjRw4r2cs4/p4cZjWewkI8+6EwcVKS0TZuNdnnprL7i4S/J43WNY7kdb7BF2hqlj6YbAj7BAxG0BPiOoDzEcn6BimOYMaxYMrKunqjF1kvDvyN//L2NoxE+d3cgy6NMu9olWrF68QtnHkqZoAm6tZ700IYi80B4/54FXjphm8xsEhEdsxXz7HIj+r70Yyfnx0jnxzyphnP4SdwDyXUFYTxtqvwpGLsVzxKAjhUif3UN9bGdNMjSCrD5HeQBKzxhVMRZzX91CjK+kGjYgsdclFTZd9seaRe3VTrLd2M/VTZZya76+8FH31I53yVbvI20WlTbcxuzsQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f2cebff-bf5f-4a93-b953-08d88427a578
X-MS-Exchange-CrossTenant-AuthSource: CH2PR11MB4262.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2020 20:48:29.2095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZmhoRYYNnMOCutM/LysrTrZDQ7snGCjzMvK3SvSPGMWplhkVqR06IJvtJEwfMSeOGdyuvwT8VA434O/NUtTZgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4405
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030103030305000103010301
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-11-04 15:54, Jarkko Sakkinen wrote:
*snip*

> Jarkko Sakkinen (14):
>   x86/sgx: Add SGX architectural data structures
>   x86/sgx: Add wrappers for ENCLS functions
>   x86/cpu/intel: Add nosgx kernel parameter
>   x86/sgx: Add SGX page allocator functions
>   x86/sgx: Add SGX misc driver interface
>   x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
>   x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
>   x86/sgx: Add SGX_IOC_ENCLAVE_INIT
>   x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
>   selftests/x86: Add a selftest for SGX
>   x86/sgx: Add a page reclaimer
>   x86/sgx: Add ptrace() support for the SGX driver
>   docs: x86/sgx: Document SGX kernel architecture
>   x86/sgx: Update MAINTAINERS
>=20
> Sean Christopherson (10):
>   x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections
>   x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
>   x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
>   x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
>   x86/cpu/intel: Detect SGX support
>   mm: Add 'mprotect' hook to struct vm_operations_struct
>   x86/vdso: Add support for exception fixup in vDSO functions
>   x86/fault: Add helper function to sanitize error code
>   x86/traps: Attempt to fixup exceptions in vDSO before signaling
>   x86/vdso: Implement a vDSO for Intel SGX enclave call

I tested Jarkko's public git master branch at the time of writing (patch =
number, commit):

01 3dbc955 Acked-By: Jethro Beekman <jethro@fortanix.com>
02 0fb18ca Acked-By: Jethro Beekman <jethro@fortanix.com>
03 8f7ab60 Acked-By: Jethro Beekman <jethro@fortanix.com>
04 358d170 Acked-By: Jethro Beekman <jethro@fortanix.com>
05 0c64b4c Acked-By: Jethro Beekman <jethro@fortanix.com>
06 b0bacb5 Acked-By: Jethro Beekman <jethro@fortanix.com>
07 e131efe Acked-By: Jethro Beekman <jethro@fortanix.com>
08 5984a2c Acked-By: Jethro Beekman <jethro@fortanix.com>
09 93b27a8 Acked-By: Jethro Beekman <jethro@fortanix.com>
10 8ec6c36 Acked-By: Jethro Beekman <jethro@fortanix.com>
11 1e67355 Tested-By: Jethro Beekman <jethro@fortanix.com>
12 9f48d02 Tested-By: Jethro Beekman <jethro@fortanix.com>
13 53f7984 Tested-By: Jethro Beekman <jethro@fortanix.com>
14 5ab939b Tested-By: Jethro Beekman <jethro@fortanix.com>
15 6caa47ae Acked-By: Jethro Beekman <jethro@fortanix.com>
16 3106551 Acked-By: Jethro Beekman <jethro@fortanix.com>
17 7193709 Acked-By: Jethro Beekman <jethro@fortanix.com>
18 9c7d634 Acked-By: Jethro Beekman <jethro@fortanix.com>
19 cad6a3d Tested-By: Jethro Beekman <jethro@fortanix.com>
20 0dadc6b Acked-By: Jethro Beekman <jethro@fortanix.com>
21 e396b6f Acked-By: Jethro Beekman <jethro@fortanix.com>
22 bfcbc47 Tested-By: Jethro Beekman <jethro@fortanix.com>
23 7a0da40 Acked-By: Jethro Beekman <jethro@fortanix.com>
24 a644dc1 Acked-By: Jethro Beekman <jethro@fortanix.com>

--
Jethro Beekman | Fortanix


--------------ms030103030305000103010301
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDgyMDQ4MjJaMC8GCSqGSIb3DQEJBDEiBCAR
NgdTAy8566hxhb5uLcaRGbZgofsd019NdrqeYAaO4zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAJVgzcQR8s/LS83OaBRxFLry4RNPLILrN0Z8YYkGCMyC15p/ZBrL
0EQMU+fdXy9vkUn420144Bba6m02h/w2/PbpDNlP/gn7tV2RBbrLfGerCc2YbHYYFF1hq67l
T0sptynIvnuI1WLSGuU8KGhqfmfGus1GpGPWs/Mi315AWEaOzf7v8VSpj2tW2TRe3TvqUeeM
dztXvkvVAbky0K9ztnpuB0hsWJy6KNd408Xbxcxb361HBR9czY0zus/Lq6dGelInKvdQzUNr
WuoDFti60RKBdAlxrABYsAxVqAjDXk0yatriPyjVGExa+gpGPVt5947eWCkm2iiEFe2bmivl
LZMAAAAAAAA=

--------------ms030103030305000103010301--
