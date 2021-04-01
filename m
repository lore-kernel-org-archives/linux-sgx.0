Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D79C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2A561374
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 17:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDARnf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhDARhS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 1 Apr 2021 13:37:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20718.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::718])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1752C0D942D;
        Thu,  1 Apr 2021 07:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nR/1Zm1mqvMEmc9Zy5xn/H9udIoG0s0OrMCg0ytO93O+azT75fOlrhFQXsq+wUaWlAXSmkjaL9Zawhue0FfzE9dCwEBAKC1coZjbHNc9bCwphihuzWBplJodonMFeCoo5bNcPMpAimVfWOpiVXe0UQpJKLFV/4q3eS+LpTYuCEnpBAsLzkx9oRemR77pa/xc56kl87oPPDs2lQ6OHIyD0F2XnxlQ0p9P0PySQqLHkPllp354eLxapQj/V+vp2MhHHtKTVU6TQCG/aWvOGqrVgP9HsgsPUxvX4e6npv7DNKptF8S3wbqnkhuy52w49v8KeJHTvy90D0lZLLnJRlpbjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6tmtdYJkQfR8RSikn/UHTb97wLC6soyI4Ne4C07Nwg=;
 b=dYMrDeJ7p2n3woJUEGp1i+GULbfNVMbkEooPjQMSsHiOZt/M+85TlqshHZz/pteoHIIPe370iT2Z9UXz7yilSoADJvDDRhPGR2JqDBvV/Pd3yuEX3+wW+z20uyox/Z25syu5QNV2VHknWLfsYYFlkaUAGFNO6I6dSsKeDoPXgLyk/t8mGotzop+Lhf60HGiVa0teWObsQyzaA15QKWzO7mfK+5Z9GDeb/YNSFShXdbCGeEM2bROJ0v7Su30Z/xfQU3ZxfTO3hQoSJqM3sxhZUz7P5htiK/RmIK4Ur9FdspDOMlDvBqI7exGnavLuiGsOP01lh1Jl2eMh2UdwOfwORw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6tmtdYJkQfR8RSikn/UHTb97wLC6soyI4Ne4C07Nwg=;
 b=SnelF+cziSThYNbXnPs5IQ9xktLc2fx67rC0PrbXMO5f0p7RntCeBPmQAmv+m6OSRBqSZwlusAgk+8xw+ryZI/vDs1edXJxfWjMmwWD0uHzkcCY+5zN7XrnrH6WmiMtxOTy1E9a3Zczf6cKC7JQClSyMCmgLJRmgVSdZ6q7Ytmg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9)
 by CO1PR11MB4978.namprd11.prod.outlook.com (2603:10b6:303:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 14:56:26 +0000
Received: from MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab]) by MWHPR11MB1792.namprd11.prod.outlook.com
 ([fe80::3cc5:3909:3985:3fab%8]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 14:56:26 +0000
Subject: Re: [PATCH RESEND 0/3] x86/sgx: eextend ioctl
To:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9688abee-6ba7-e1d9-701e-a5cabac36269@fortanix.com>
 <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Autocrypt: addr=raoul.strackx@fortanix.com; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkYyb2lmOEJFQURN
 UkFMT1ZjRkYyTlQva1FsWTBtVnN3YlMrYi9WNzR1azZFcDdxenpoNHpHbEtSS1pzClplS0I4
 WmpFT2h5Q2pZaExwdnJHTVh2cTV1bm5pWENIbG9BR1hZRm9rN0Q0SGd2Q0djYnlTYVRMQjds
 NHc4MFIKOStYUkp2SnJpMEdPSmVubjRnNUpIQU5RN2h5YWl5RlRIYTVERU5CMjc2VG9kZUFQ
 bnVidGl1VmRDT0lnQVJVbAp1dzJHemFsbmY0WmZ1TGdEaHg5YzIza2pjZTFBQkFWbWdxUEtN
 TkVUSnhyZFdLQUt5QkVIWGJ0Snh6YnR4bFI1CnFUZU8yTExCU2V4TFBDbTRZOTZzRHlGK3JJ
 a2FpRk5JQWk2b3RrTFBxYkROUlB4OTdLTTkzcmh5dVpIaWVQM1gKNWY5dG8vN0xEcGhqV0ds
 L0ZBcldmT2U1QTgxTnhoTG5GNm9kakMrN2JwakdkNXdvM2E5TTkya2wyelJ1bEhSUAoreFFY
 T2Z4NkNoNnBMSVkvbmRtSGZOVDA2ZTBCUkt1MlZxWEw4Y2Y1a2pkMW4waW1vU0FxOElGNmFq
 UThBdHl0CkR1T3JpTk82WGFQRVlqaHVvTzF5YnBFeDJCWE95N3J4aUN5WFlkSldJVmY3T29a
 c0xEM0wzTHBYM2Q4K1hZYXUKeWxab2dVaFErMHpoWlhBVnExSEkzc2duNnFIZ2RTT0J6aUJI
 cnhycGFvUnRhQkREL0I5WFhyM0FOTDhZWG9BegpISzJ4bDhhQTg1eWt0THlBNVc5WU1GS2Jj
 UXIrR1VuNStCNWRlOFN4SDgzTkR6TkljNnhtYUtKTU9xdGFiK2hHCmhRUEdtcDlmNDdGQmQ2
 QkhLYzFBSHJ2OElteDAyNVdYc1lBakpZbkVlMzI1dW5MeXlUTlB5VFo0NFFBUkFRQUIKdENw
 U1lXOTFiQ0JUZEhKaFkydDRJRHh5WVc5MWJDNXpkSEpoWTJ0NFFHWnZjblJoYm1sNExtTnZi
 VDZKQWp3RQpFd0VJQUNjRkFsMm9pZjhDR3lNRkNRbG1BWUFGQ3drSUJ3SUdGUWdKQ2dzQ0JC
 WUNBd0VDSGdFQ0Y0QUFDZ2tRCkFrY1ROU0RvS1ZoU1B3LzQ4T0FoUExHVndWSGtsSnE0QktK
 ckUrc0xTMjY4RnIyeEg5SlNaN3B5YU83bm5aYXcKcjNHL0dEVmN6L0FWZVZCQXY1OW8xMW9y
 TmFZdFAvUzdhOWFFbUl2bVZJZitvaW9ZaXh5eXlNZk9obFNmZnloagplWkg4ZC9OZDJTajJ3
 SXJ5S1BxNm9rYWY1N2pVR1dlbEFaNUZaUWJQNzFlU2E2dzNtcmQ5L1NOTFdFVTNPNWloCjRs
 em9HT1Fob2R6Qms2Yzh4UjZsQzJ3OHVyRkYrRnRhcmxwNkhxbWVBeHdXeHVQVDh4ZDhCMERl
 ODFFbjZIMFYKNjA0ekdsa0dYS1VTdXZJVHltdzEzYTJqYXQzTTRFTjNRb0lsbG5hN3N3ckly
 K3l4aTB3NzgvczZEU2dtVmFIZgozd0lncllMNDEwRnpCeVY1RzBDTlVuZ3lnL0d5ZWFiUVl0
 ZU04NHMwRXdMRFFkWSsrYXBZN1FYVEE1d1J6bFJNClRyc0s0MDBndlF5d2lPandST2x3U1oy
 L2QwSjBJdXNFdnpzQXIzbUNIQTRXWnNaeWpsT3Z1UXE4LzR0ekNKN1UKVTRvVUxMWll4ZkQ3
 Y1BVQXRTanBnNTFiVGhoai9nZXJDN1p4Sk1nSDM1MWR6RlowS2xsVUpHRU5QSmJkRFZ3WgpW
 c2lHRjdtcXVXVEwwQmpLYXl3ekgwZWdLVlh2ek56NXlrbjhJMDlTM3VvY09jSjU1bnNhR3pT
 WXlnZ3k3eGRoCitTMjVEVjMzWXNobU0vcGdXWW5IL3BUQzRDQUpmaGVpU0Yyd2EyR1g1bUZF
 QVBaQmh2Q0I2SzlXdkNKbEZXVzcKZTZ0dUpPRGdNUklQLzJ0SHJIMEFiMmFyVWJFWjhpaEdM
 L1pXcUIyRHlkeTJDVjU2ZjdjWVZBSndJTGtDRFFSZApxSW4vQVJBQXVEbXlwU3U1K3BFdlRt
 QzBBY2NUbVZnbm8xKzA0SllzckcvbVVuMG11cmFHM0xnZWtWMWVJWTVQCjVpYW05OEhiL2pI
 MU9kVXM5R1VCNCtLU1d4SnJERmNXNkZOcjJiZ1V1Y24wZm1XRHdOWU5oWGxJd0ZHMGRaV3MK
 SzNuRWlNSXJTTnhnSzBmS21jU2lpaTJhZlRMMkFTVm5JM09RcUN0RGhpU0VEWkJ3eW5BeDIx
 Nk4ydklNRFJVMQpiS05oVzRvNnk2R3BHNUdVQ2VBZnZ6SE5lMUNEbzQyQm5CRXUrVmlZYUE0
 cERrZ3hjaC8ydk5YQTBtc25rY1BiClJmcVlhOElpSVVTUG91WWVneHZ5dVJjbEhadFA3TW5n
 V2ZRSmxwQVlIOHdJWExUSTlScUpmTTM1K0xZRTNQR3kKS0RYZmE3MWFFUjkxcUJWMDQzMkNn
 KzFQN3pJUERTR0w2TEZJaFRBTE5TV05TRFU2NXpKWlNkY1NVQ21raytWZApqZkdGbk5LeEpW
 OGl2ckN2TGZMY2VpQWFWK2RHaGc0WkFWWStscVdFSGxYNW03V1JXQ1Jjb3pDNUd1TlVIeW90
 CngydVpHQys2TDVPTGVXeTZoUlhGSWdZWURLaWNnYTAzZjQ2WWorcDdKaTlWTGxvYWIyU0xO
 YlJFOERpK0xUWmQKempBMjQ4cDNTMDJpM1h5K3cxeGs4Q1VzOHVtMjlYNTVEaGtDSXdDdk5i
 Y3ZZcGtneTNjU3dZL2JmMm4xUnZ4aAo3MldxM2JBYXlVdC9yV0JFRTlTWkZ0cXRITUpCWVFX
 eDh3S244TVl5MU54YmpWZ0J0cVVaakdycW5OV3lnRStNCmFJZ3RpcUM4Q1VaU1c3dThMVW5a
 OUlaaGEzL2h1c0pJNXRmTHc5RmhTNXMvRzh6bWl3OEFFUUVBQVlrQ0pRUVkKQVFnQUR3VUNY
 YWlKL3dJYkRBVUpDV1lCZ0FBS0NSQUNSeE0xSU9ncFdHMlpELzQ1dFpmOFlvUkUxcHRQd3ov
 OQo5S3BIdFp5TUt5NFZLNmxXWDRCNnpHZ0hpcXpIQi9lekpwOEEzaitNc2FjM0hMZmtHdjVN
 UWYwRnNYUnBCZWhJClYrU0FBUmw3SktzM3pUck13TDU4QXpnNk5nbG5DZDNaYXQxU2hlWkhQ
 dVdXTUdCeERPMUg2UFI2NmRGWVJIM2MKODVaZHNHdWFobnJVSFBLemhZbWx4dUhDQ3FCZ3RK
 am9wS2NWVGsxRnRLVGUyZHJ3Z25Bb1M2dkh4bTdRTWxJVwpaMTluS25GOFAyN0pFanU0ckdX
 Z1h3NkgxSmFKMTF4YVVkZG9qdk53T1RKRVcvb3Jhd2tuUUF1ZW5EYnpBR1Z1CkdMV0w3T2ov
 RGZyTFBBemNXV25GblV2VVc2NEFEWFNBOTh0SWNBY3lod05uY2lqYnNIUkFTQlJidkg5RFhJ
 c2wKaEwxMDArdzZNTWNMeFpNVmJ4UHBTWWVHaGp4SjdNUysyeGp3eDB4MWlMNmszZk5UNHNT
 Q3dZa0xRZjJlKzhxYwpFYjNTa0Q0VFR3RDQxUW85SFNuUlkwdnRqblNyZkwyQ3JhVmptOXhh
 MXhmNlJDQ3kvaXpKNU5TQTZZMXduT0U3Ck1IOHorcVFUM1NxMld0a0NzU1M5K1U2VU9OWmFK
 dFN5MWNvZ1ZhMDV1QWdRY0tHT3FvcHg3QWlmZUhIUFpqZnIKakVNaHJZQ3Q5WXgzR1VET0hs
 MnRObDJIOStqZC9BVjByMDRKUTNxSHRWM1Z5UTNxN0N1UTlCTTdnQzVpK1JleQpHSU14Zm0v
 a09GWTRLRUxOeVYrV01PK2lXRHpZS21tTUxnUkVXNitqZk5jMzhrYWhaQjI2RmJOZTh6QmxU
 cVpPCmhxYmNZR1ZZNW9Ec004YSthbkwyZDhmaStnPT0KPW9ZT0QKLS0tLS1FTkQgUEdQIFBV
 QkxJQyBLRVkgQkxPQ0stLS0tLQo=
Message-ID: <ece49a38-c84d-dba7-6039-b409511e7303@fortanix.com>
Date:   Thu, 1 Apr 2021 16:56:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <c7b19652-3b5a-e864-1e0e-3e3d26944398@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: AM4PR0101CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::42) To MWHPR11MB1792.namprd11.prod.outlook.com
 (2603:10b6:300:10b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by AM4PR0101CA0074.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Thu, 1 Apr 2021 14:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4661510-3e73-44fc-cfa4-08d8f51e52cd
X-MS-TrafficTypeDiagnostic: CO1PR11MB4978:
X-Microsoft-Antispam-PRVS: <CO1PR11MB497814FFADB3903079DDEFD18B7B9@CO1PR11MB4978.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2p19IfAi4UvJG7DqNjjSviPypw13ZV3pG4QIfQ4CunClzmwS0A8LVyQEGl+rAYClLulH/MPcGIa56gEyU8hW/nEgqsRB3jbVXmoLsJeGLr0oIdBxIAsa2jfUFEfJawEgP+fjjKgcV+/d35RvvurTap2lwuQor6XKww68t69Z5F5TjEOq6P5wd2YVt9LFV7RfPEOC4SGf/lJJfMivROB0wpUosiiBveeU9m7/Lg/WHUKvisp6FvZELnwipylAm/h2MG0s3gyK3XK2O+ckr/W2nyreWcgjgTPrhA6Q0CLJWFWSthhzvnsXXP0GTXWN5OaK6W5iaeTuGHz1IPuLYd9+fWWpG8hBi6pHJ4HrWAnnhEZcwPnwFCpSGus2euBwv8vpSZ48zjExTxAveQTMJ95/Zyte0homQrEl4VHHPi22jLpqW+ziLZDyiCYs3VdgGgP53lDayzZ024fhqg5KLRNLs5DxqbSBgVqGBgeb0DgrdX0bZQuBBV9PcIPZOd82TZcjTr441rXU2wQE0W1kVQBOkmZZMx/HZ2tCPupLrsv0/oLzw2RaUOUGRRqupXeYWH4v3ps1LgVhfkEkjEsLNPkNybgzMv585ujoPAekQeU3XCZMXKEaVJiraLILsGE5Lz7KKa74qNLwmIZ3MDKZ6IkQLGULq1OCqhVQmdBW1GhFm/f3uvdft+ZK0KncW6lxPk7zsOpWqogOsCg0lUK7Mjx6IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39840400004)(346002)(376002)(478600001)(66556008)(52116002)(66476007)(31696002)(316002)(66946007)(16576012)(110136005)(7416002)(5660300002)(53546011)(31686004)(6486002)(44832011)(6666004)(2616005)(186003)(956004)(26005)(86362001)(83380400001)(8676002)(8936002)(36756003)(38100700001)(921005)(2906002)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YXBkSW41d1FhWndORmlhSmh0eFdzbis0eWU3R3lKT0VFbVk3THBodFpvUk05?=
 =?utf-8?B?L0ZuMTd1YUs2anVjMDk0UzhoVThSOE9Mam1adU1QU2ZZUnhsOVpsdE1FTlRw?=
 =?utf-8?B?bGswajVIOUFWYS9rVmFFRTV4SzF0QURaZkowakt2bDhYVENKUHl1RUNwRHg3?=
 =?utf-8?B?N1JyWXZ2dWNQczRicStHSS93NzVTc2V3MklvblN5dFZqTmkvR0RjN2lBR3lZ?=
 =?utf-8?B?bzZVYXBJSXFQTWMwVXR6NllGT2trMUY3L2Z5RVU4WmJBbmlJVk91UkVqVC9p?=
 =?utf-8?B?bkdLMWJVN1BUb0hpc0J5TVFEelFrNWdLMEY1bGRJUXNuT0pxaDIrVUtZZHZu?=
 =?utf-8?B?N1B6ZHhDUC9uOG9Uc2hpWVUrWlorNHFpdm1paU9oNmhpMzZycDRBT0xMeWV5?=
 =?utf-8?B?cGttKzdKWXQxNzRhMWVlbG1KcXlOQXJXN2JDQlp1dU5KNkgzVmRBOWNyOExY?=
 =?utf-8?B?U2J5dTV2Ni9wdlJzVm9wNi9jb2ZHMklreUxqZi9MRWJVZzlCaU9xOEVKQzA2?=
 =?utf-8?B?dENqcW1kOVRpcUV3RnpGU3E4Y2kydjRpeG1MVDRoQjFzSFc4akhoRnNlQUsz?=
 =?utf-8?B?VXhpbnNwM2E3YVJvMmVYNXJFTGVWUE10MVVQOXNvc1hOaFg5aHB6ckRmeSt3?=
 =?utf-8?B?ZlQ3RGhwVEx2REIwWEVCSzVqU1l0RGtFQXpvbVNjUzBiVmhWeHYydnVSNjZv?=
 =?utf-8?B?VWd5NEpwWTlNZ0w0KzR0RWhtSXRhdFVsOEU4aFg4T1Jrc1ZyK1RuUksxdExh?=
 =?utf-8?B?UThUazkwNFJLK1d3RlF4MGRLWjBjbStHR0luVzg0Z2k4RUJDUVQyVVdCa3RD?=
 =?utf-8?B?bVoxZHpzSGFuZWhFdEdhZEYwMldoZURXLzBGYTROT1JWZFpXek8vRFNHMUta?=
 =?utf-8?B?ZnJDcHpvbTF5L2ErK1prRHdSZnBCQ2wwVWNJZzdNWEZ3eEpEMHQ4T2ZPdzNT?=
 =?utf-8?B?OGovNFg0UEUxMXZMY0l4Q2grQ0hzcFphSGxtNkdvbVpROW1mRmpJczRQR2Fo?=
 =?utf-8?B?RXl0U0VFYWt3eTFnVi9jUU5VN3JsTFFQalJnZWVmUHJzTUlOT3ZneVRoVkRr?=
 =?utf-8?B?a09FWi90amgyb2NIRmlxZjYxYzRDZW00WWQrNzB6NXJjK1IxYmN6d0Fmc3hO?=
 =?utf-8?B?dVMvczdLb09JeENvTW5JU2dyWk0yN0pvOUYrZmlyMERRelpJRFVWV2lSS1Ax?=
 =?utf-8?B?OWxDcnZqbHl3L2U5MFY3R3hWWjZzU2lOeGNQUkNUQS94TG5POFR4TjFSMFZV?=
 =?utf-8?B?M1FFbjhZTGlyZkVRVzVjQmNNTUNNMEluVmtmaEc2bHptcTVudDQ5bXhDREVs?=
 =?utf-8?B?NmRRRGZ1UitqYnJmQTEwY3RzOUtmY1NDUXlwUWpmbzg2aE8yb1BLZDExUGpq?=
 =?utf-8?B?MnFEbEIwaFp6bFBNenVUZ0FVQVBnZjRGUXJpQ05leEt6VjVKSS9LL2l3Ukha?=
 =?utf-8?B?c0VSMndoK3hqck9nM2RBSUZxcTlqZGsrdWU3QlR1TUNWbUhURWwyRjVuTmxw?=
 =?utf-8?B?Y2RpajgxVUs2dDBMUm1kRy9SMnpQVEdQTml0Y1o4TUdFSGdQek1OeGxjN0tu?=
 =?utf-8?B?SEVMQWJXUEZjakQrMHNQQm1LaUUwSk53cEVRTEFSdThUNGZETkdkNURFclZZ?=
 =?utf-8?B?VDlXQ3dPUGkrREFBWnhmQ0daNHlmVWh4azZvYVRFOGJ3dFgwWWc3TWx1anZn?=
 =?utf-8?B?elNMc0NqZTBodXN6TWNXQkhrYmU3T25VY2VkRVVuRXFHbGYvcEE5VXFCK3lS?=
 =?utf-8?Q?AdhAGYRaCi9eatys+kuTdgudESQo4IDxtI98bev?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4661510-3e73-44fc-cfa4-08d8f51e52cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 14:56:26.2757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zj/sUxzR+PQBlqHWlL5Ml8Iys3UclUO74Xww2+uTu2WLGx1FbvgWr8+WP1990PGLA8ohSSiqLnnXdbonnlljtr0LpblYjdi09WTzOLpyNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4978
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/31/21 5:53 PM, Dave Hansen wrote:
> On 3/31/21 5:50 AM, Raoul Strackx wrote:
>> The sgx driver can only load enclaves whose pages are fully measured.
>> This may exclude existing enclaves from running. This patch adds a
>> new ioctl to measure 256 byte chunks at a time.
> 
> The changelogs here are pretty sparse.  Could you explain in a bit more
> detail what's going on?
> 
> A review of the relevant pieces of the SGX architecture would be
> appreciated.
> 

Yes the explanation was very succinct. A more elaborate explanation:

BACKGROUND
Creation of an SGX enclave consists of three steps. First, a new enclave 
environment is created by the ECREATE leaf function. Some enclave settings 
are specified at this step by passing an SGX Enclave Control Structure 
(SECS) that contains the enclave MRENCLAVE, MRSIGNER, etc. This 
instruction also starts a cryptographic log of the enclave being built. 
(This log should eventually result in the MRENCLAVE.)
Second, pages are added to the enclave. The EADD leaf function copies 4KB 
data to an empty EPC page. The cryptographic log records (among other 
properties) the location and access rights of the page being added. It 
_does not_ include a measurement of the page content. When the enclave 
writer wishes to ensure the content of the enclave page as well, she must 
use the EEXTEND leaf function. Extending the enclave cryptographic log can 
only be done per 256 bytes. Extending the log with a full 4K page thus 
requires 16 invocations of the EEXTEND leaf function.
Finally, the enclave is finalized by the EINIT leaf function. Any new 
invocations of the EADD or EEXTEND leaf functions will result in a fault. 
With EINIT a number of checks are performed as well. A cryptographic hash 
is computed over the final cryptographic log and compared to the MRENCLAVE 
field of the SECS structure passed to the ECREATE leaf function (see step 
one). The signature (MRSIGNER) over this MRENCLAVE is verified as well. 
When all checks pass, the enclave enters an executable state.

PROBLEM STATEMENT
The SGX driver currently only supports extending the cryptographic log as 
part of the EADD leaf function and _must_ measure full 4K pages. Not all 
enclaves may have been constructed within these constraints. Such enclaves 
currently cannot be build on the Linux platform. Trying to do so will 
result in a different cryptographic log; the MRENCLAVE specified at 
enclave creation time will not match the cryptographic log kept by the 
processor and EINIT will fail.

SOLUTION OF THIS PATCH
This patch adds a new ioctl to enable userspace to execute EEXTEND leaf 
functions per 256 bytes of enclave memory. This enables enclaves to be 
build as specified by enclave providers.



I'm still very new to how Linux kernel patches are handled. Where
would such a more elaborate description usually go: the cover page, the
commit that introduces the ioctl or both?

Regards,
Raoul

