Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660DCC4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434C760FE6
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Aug 2021 13:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhHRNat (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Aug 2021 09:30:49 -0400
Received: from mail-dm3nam07on2092.outbound.protection.outlook.com ([40.107.95.92]:38656
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235943AbhHRNas (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Aug 2021 09:30:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iq+CtByb2frCXZIqfOI42AL7Y2d0xgcUug4ROrJWxJXDR7efUeIuRsHIcbzt+94os+AogFmZFSy2mDlscYf8AdzSKhS/kmQ3Fk8uCnFxmbz1iVEkzFQvjDTUQ24UEC9DpMjj7v1xnR+62LjbqnSAEf+QNqrQa0RMtBnjBNC4QPW0TcElrXYJE3ODW+x3VLPGM/u28r0gpkv1NyRBtyjnq5uGG6qUPoxkjyljwsaQzmmbcU4lxOkIu5cTxLTLKRU+hBZArg8M6Urv1x/ayVHNoa88ZY2uHlFesmHpHMLtD5/ippYAvtcG0ozPvfjXYTwEon2krBnBWaSoX41uYGy/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22R/c1gVMjw1jVFzTymribX/1zQSPaKRNyU04U3LVuQ=;
 b=AbhIsxKNc4kQbIW0zL+jQoiKxfchXSdAmlr/xXV+DzPkxsXSqfls7ruIP05t+Ax/9yVJuBN0viUcr0221BEcksLysRi6UXAwyKWTTLglYasQxakYPRPKJRrrS9G91a6Upu6FsWU8XWK879Lr6rIDzmXyXAkDnquEE5BYYzM4tctwrGbCdrcU86zd8eWXGKkCTbPhj8LgZvvEzjOlIMWxsJ3RsBx310BjKCv20eaYUUfPc0xpbs/ZMXfkEkQ10OhBC7hVFUIKe90Dr7gp8uVUtDbgN/5uOd9rLcHOsxEkGbwJFsyxxJgBlHCQYznh783IdHq2iGNK9Eef1pYH9AyVoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22R/c1gVMjw1jVFzTymribX/1zQSPaKRNyU04U3LVuQ=;
 b=QK1AcW49w0/5RtKPdtb6XqngQx75Zjk/epcrY4Tiz7b3AnGrnKCXy2cBYdk0LhMIdH6bOiIO2LVD003ROe43qZzUcMtrGMZeQ83IHrFWu+ZciDZFu2rJcsOABYbNdAHkxPOy7/Afizkv75gH+q/NLxjHxKh82UxQQuLs47abPPI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by PH0PR11MB5676.namprd11.prod.outlook.com (2603:10b6:510:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 18 Aug
 2021 13:30:11 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::ec79:47b3:ccfe:102e]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::ec79:47b3:ccfe:102e%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 13:30:10 +0000
Subject: Re: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20210818132509.545997-1-jarkko@kernel.org>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <acd5a925-ce86-9934-5e1c-d0bcee3f606b@fortanix.com>
Date:   Wed, 18 Aug 2021 15:29:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210818132509.545997-1-jarkko@kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010209050102050605030906"
X-ClientProxiedBy: AM3PR07CA0145.eurprd07.prod.outlook.com
 (2603:10a6:207:8::31) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.127.206) by AM3PR07CA0145.eurprd07.prod.outlook.com (2603:10a6:207:8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Wed, 18 Aug 2021 13:30:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d2b432-a270-4518-2ff2-08d9624c4d5d
X-MS-TrafficTypeDiagnostic: PH0PR11MB5676:
X-Microsoft-Antispam-PRVS: <PH0PR11MB56766500887C5D0947D467EAAAFF9@PH0PR11MB5676.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dJ5Qycl99KVFUCJRbLLtFdnzFPTkbxuw0mGFkCbrN8+tMhXMg3yyW4uwpxnSaIokFjjvYfDBPMcvPmbz51MaR17wJk/AgEg6JHa1C2mrF1qhc6q9Gstk0uKJhh4XkdH/8YyliMbaVoKUYAxaF3yFErfDD8+QBs9ZOhCb6vxL5QKNZuaP/MX1mGKBNLqhrbVoWjSS1uSgja5+HLiLTx1PhpvBYuBCpFmppREY4CyaY5UqV64UfXgeeuuMj/0tUPxOT7k1rjPFWVhdD9bn5ZN7cgYTC0MYlW5x8HhACrndzFLbQmlD/GLJScN8+JK40iuReYuoJXOiKoLsbu8vnAfEX39wqYUwTYWP+fq4eyV5vtukFHfZ100k1WYgkMhGAj8k899ANfnCITaUbV4apTyKfk3IqWoJdj8Nl8uoZzByl85tMj4+DpqYE8az68gfottiMX5N8NjRUMvR66wnGva0G/j23zWtFJRLpuq6oWntbM5qHCK2ZfmvUVP69LRQa/I8lNygA/h4zYmKb+Gk7uFwN5LVKB14ckPtdyhBsdcNAsj6OZqX5ohBMCcN93HpsVk0GJ0+Px/BD9nzA+AoUnncsd987rSU7+nFZWCgqrQ/R+Me7h3DTmgzth+A5mCTTqgmm7nSt7plZuAB9vLo6kVG5du/s5q3HjWPBjSyCh9BcQssURuJUkP5xmIDmy5cPGyUxFoA0xV96NVaD7BMGmr48HQ/hNr5cKxSMen0ovaQ+9H+jsA1NgpMqAygJfJJaIwEb2MrNh/CtYru3eEcwVYtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39840400004)(136003)(8676002)(26005)(16576012)(54906003)(52116002)(8936002)(316002)(33964004)(235185007)(478600001)(53546011)(2616005)(5660300002)(956004)(36756003)(6486002)(6666004)(66476007)(86362001)(38100700002)(38350700002)(66556008)(83380400001)(31696002)(31686004)(7416002)(186003)(2906002)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnJzRTdIcHM0SVRBS2xhYXY4UEx6WWlXbHRUWmc1dXpPTU5tRDZuTG9DWVB0?=
 =?utf-8?B?eUE1MnNMa2htbzFaZTVuSlp1WklQYlJIejYrVlQramR2bjVINU1JVHNFVEJz?=
 =?utf-8?B?M1FTamJDZlJFWER1OWVIM2FpRm00S2dTV3UxbE1LVzUvNHFtQjgyQi9saFYw?=
 =?utf-8?B?ZDNtZmFudmVRTzdjTzFkbXc0aEhlSExOaTNqeGtUQkExUERtRUFDdVZyVHEr?=
 =?utf-8?B?YUNzM0Q4YlcxNkZOcHlkZUpkM1F1cXdqS3RZaGRiVWRkenZobjlhTGJ1RkJH?=
 =?utf-8?B?SDhDdHVHcHc0blB0Qm9UY2xPVWpvWHJkdXF1bTRxMGxsM2diUThXeEY3dzZa?=
 =?utf-8?B?SUtSNm1henBRbkp1V3FDNmE5ZTNzZ3BrSTU4Y0ZZUWM2MHlXQWt5SEt0bEF5?=
 =?utf-8?B?a0tIdzE2UUxEaWYzaXNiZXlSZ0hEVGwrNDdwK1lOV0VEVjJtUFVGaUlLUXda?=
 =?utf-8?B?dlduWFVjcUl3Ky9lZkNwR2dFTzFzS25OU1hWVXpnb2o5elBMZnJKNXhIdW5B?=
 =?utf-8?B?VFFvZUpZTXVvYXFrM1JYWUlFTG9VcDZtLzA0MFFRaUMxK0JmaHAxdm5TSkNi?=
 =?utf-8?B?bUdQU2diczZnRGl6eThQS09DQ1lMV3pWRnJ4bmJ2VXprNWhXL0dFZmFNTm9r?=
 =?utf-8?B?R2txZ3dob3dzR3pNblcreW0ranNlK2dSNWlMUjJZdjdlR3pCUGFEck51M1BU?=
 =?utf-8?B?b0dqc1NuS0FsMWZlb3JGNFhWcFlEMXZkYXZKOVZrcmlFSktQVkExNEpLNEhw?=
 =?utf-8?B?ZUFyTmVlVmhNUTJzRUVocis4VkVIck9sZnl1ckhBbFN2TTBIeXN1WGZERjgw?=
 =?utf-8?B?Y2dzOGFUaVplU0hKQzlPb2ZSK2dnTFltd2I3N2VTbitDVTUvZnRLRXc4Zk9w?=
 =?utf-8?B?MVRiTEpRaWdvRFczRDFTTUg5WWZRYkJGbkc1M0Rja1QxTTY5ZVNJSnNwdmo4?=
 =?utf-8?B?SEwvc0R3Vnp2blcrdHgvV1NIU2V3T3NjMVNtUDlHU2FQMDB4dVRYanVSZDVu?=
 =?utf-8?B?ZnFETExCcUI1aVFYVnRCSHJ2bTZvNExGOEFWUjIrM21iTE1uSFNFeXFZZUJh?=
 =?utf-8?B?UXB3TWc2WlJpeC8zejV4Rk15R3ByNkRtdWZXMC9DNy81ZFZwaHRvN2xodzJy?=
 =?utf-8?B?c20xb3gwbG1qZlRQbVE1RVp2REZiQjFJb01wNS9IZ3NEZ1o0ZDZaUGpMNGFI?=
 =?utf-8?B?Z2VNT1BXMEphcUV4MW5XRzJ4RmdiZDY4UEdMaHZFd21IL2VlSkkzUjNCNDFy?=
 =?utf-8?B?VGYrc1kwVVhSSlN2RktLMU5OdWRRUmxPQWEzb1Bwd2ZlQlhOMEVQa20wa1hx?=
 =?utf-8?B?bnlMdHJVUXQ4eG5NTW5uS0J1T2dKWXBqaEtXcVU1cFdEZ0JNbEZBRkNYZGx6?=
 =?utf-8?B?WS9tSXVqRzlGZWdhTk1tRTJMS0VjMGcwOW1rTlhrNTg3d2h5ZE5lVGRaOXVE?=
 =?utf-8?B?aXUrcmsxZ3AzNGdHOFIxeTBkdVYvOEMvYWtNYnpweU0xY3NjRlFRUjUydTZ1?=
 =?utf-8?B?VWFJaStsWUk0cVdzbFBlb1dJWkxLMFJGWW5JOTc1YlVpK2s2TWVEbVlkK3po?=
 =?utf-8?B?Nlo4TWJBV2crN3JHWFp5Smw3Z1g5OTEwdm5DWDVVUC83b1FPaFJvbngwRVdE?=
 =?utf-8?B?bDEwYzJvK203b0JBZDErNSszR1dBdkUyaUVqcEN3ck9VSkd6NmwrZEhZakFC?=
 =?utf-8?B?aGgza3R5c3ViNGtaT3htcHB2SU1JSFJkbERJV2xqMTI1dnVpRWEvVm9obFlE?=
 =?utf-8?Q?O4zXb8xA0sbFDSbzdemL4JZoX+K07JE6oeB6Suf?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d2b432-a270-4518-2ff2-08d9624c4d5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 13:30:10.7841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqeVz8pjYGeYIHHOniakx4cZzCr9sutGhPrSDSgdaNdI9ZDNbFvVPkaQ8wx8bpGRS5Uc/j2R4o0DdYysXCVsYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5676
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010209050102050605030906
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2021-08-18 15:25, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it=

> varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> sometimes useful to know the amount of usable SGX memory in the system.=

>=20
> Add SGX_MemTotal field to /proc/meminfo, which shows the total amount o=
f
> usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from=

> BIOS, the printout would be:
>=20
> SGX_MemTotal:      22528 kB
>=20
> It is less than 32 MB because some of the space is reserved for Enclave=

> Page Cache Metadata (EPCM), which contains state variables for all the
> pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> which applications can use to create enclaves.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  Documentation/x86/sgx.rst      |  6 ++++++
>  arch/x86/include/asm/sgx.h     | 10 +++++++---
>  arch/x86/kernel/cpu/sgx/main.c |  7 ++++++-
>  arch/x86/mm/pat/set_memory.c   |  5 +++++
>  4 files changed, 24 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index dd0ac96ff9ef..68ee171e1d8f 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the h=
ost and in guests
>  on the same machine, the user should reserve enough EPC (by taking out=

>  total virtual EPC size of all SGX VMs from the physical EPC size) for
>  host SGX applications so they can run with acceptable performance.
> +
> +Supplemental fields for /proc/meminfo
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +SGX_MemTotal
> +	The total usable SGX protected memory in kilobytes.
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 05f3e21f01a7..2ae9dc8c9411 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -365,6 +365,13 @@ struct sgx_sigstruct {
>   * comment!
>   */
> =20
> +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
> +extern unsigned long sgx_nr_all_pages;
> +
> +int sgx_set_attribute(unsigned long *allowed_attributes,
> +		      unsigned int attribute_fd);
> +#endif
> +
>  #ifdef CONFIG_X86_SGX_KVM
>  int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,=

>  		     int *trapnr);
> @@ -372,7 +379,4 @@ int sgx_virt_einit(void __user *sigstruct, void __u=
ser *token,
>  		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
>  #endif
> =20
> -int sgx_set_attribute(unsigned long *allowed_attributes,
> -		      unsigned int attribute_fd);
> -

This change seems unrelated?

>  #endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> index 63d3de02bbcc..1fe26a8e80dc 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> =20
> -/* The free page list lock protected variables prepend the lock. */
> +/* The number of usable EPC pages in the system. */
> +unsigned long sgx_nr_all_pages;
> +
> +/* The number of free EPC pages in all nodes. */
>  static unsigned long sgx_nr_free_pages;
> =20
>  /* Nodes with one or more EPC sections. */
> @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_a=
ddr, u64 size,
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
> =20
> +	sgx_nr_all_pages +=3D nr_pages;
> +
>  	return true;
>  }
> =20
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.=
c
> index ad8a5c586a35..82bb09c298de 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,7 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/sgx.h>
> =20
>  #include "../mm_internal.h"
> =20
> @@ -116,6 +117,10 @@ void arch_report_meminfo(struct seq_file *m)
>  	if (direct_gbpages)
>  		seq_printf(m, "DirectMap1G:    %8lu kB\n",
>  			direct_pages_count[PG_LEVEL_1G] << 20);
> +
> +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
> +	seq_printf(m, "SGX_MemTotal:   %8lu kB\n", sgx_nr_all_pages << 2);
> +#endif
>  }
>  #else
>  static inline void split_page_count(int level) { }
>=20


--------------ms010209050102050605030906
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA4MTgxMzI5NTlaMC8GCSqGSIb3DQEJBDEiBCAW
qg4YwgxKqst1RavHQYjYAngc0SfKLga6HK+/rgRg8TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAGyPoVL2yB9XRzheD2d1eNwOvT7Xbbsd9/IBuM/6ks1tqfwyFPho
RbV1LLX15EBdRN0aZURG6vgSSaeki39n/RicvML5/aC0bZFSwP7gpwdYFym+dQM2vKZ7R980
wiWGtY6LErf0fizm2w8z0JByoGQ68eirlzDbJOuA9y4T/w9aB6DjuBJxIHpI3bsYl5QVbWGw
Jd281h/3SwgWqsiq21YQngFV2WDxYkkMORnMLceG+MlokGzz4taUWawk2hLEnWYHAVhxJmUV
5cXWqysO/SR/2Rny/ylCxjpWgVtGWowzq+3Hk3TXDVApz23td7O5rF1uLdOunyhmlv4ddWgo
Gp4AAAAAAAA=

--------------ms010209050102050605030906--
