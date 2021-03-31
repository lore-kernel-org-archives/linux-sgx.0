Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999CFC433ED
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4520961964
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 12:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhCaMwB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:52:01 -0400
Received: from mail-dm6nam10on2107.outbound.protection.outlook.com ([40.107.93.107]:56800
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235641AbhCaMv0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 08:51:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKJXUz2G45/IexApU+uQCxOpZEEfmwE6F7Kz2PHo3FU8YBoe7HEBWG57PgAXJTWSZpGrvuWayo4rW8qLKKPz4yM1+T5ICNgcs/cb3lxFeO8RDExsNaoQ/58orbgo2defcotlkYmxIYQY5ifcXy6Dc2arUI8Vgfow0K8biJ2B3W/A8cY8GhI2c8ZfUXBB5FPn5ynm7S/r2vJycKoyUfaGoj5bbLrvGQ8YL4sdkq4uJnxC7/xQQuc6mNSYYmevn+9JzRKvIPcTOqD+O0UFnJ5OCYJxggxgAlbZ11QJRo5oWrVWO9fAB+WZanodG0oO6oWW0hnZ+RGJtqRSIiYOkFLIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV0ZY0FenLXeEWER/+oEQgXObGUTdxJ8AzO6ezD5LKE=;
 b=oQr62BAIY4fCi+5zrK9mgz6DvEWtXYWHXcbiCalOFziyPyZl62gfQWPmWSF//vOPGu4AZ0gEjev6QGzvDnVFSGGa08MYYzNLsBdt+DVSDbxwHluul64YGpKX8LV9NLUxGiRq0enQN5+1bHXax28Ay03aSGV9y8rOahR50KqtpYmmF0+2S0NtOzu7QbjHSvVOZw9JLgzAeQLO+I+LjbmCTl07lOv70fZp1IdI1binuS92+xyopGliWoyfM2MNWmFzcBYIC0FkkL5xQHsWmV82nuQrtqIZo4UwBZlZKyXVWf/XBXrrn0mqpfYd+IZjNCFqtLPvEnpoakyr2xwXcMIt7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV0ZY0FenLXeEWER/+oEQgXObGUTdxJ8AzO6ezD5LKE=;
 b=Mr2jKztanb61rsn/MCmWIXV5LHX5XlCP5JRSxSFvZMvngMD2iyfML5p0kJ2Kfh90ToL4vM+yn6a8IjeUOSZUwQPdDHE2Ly68/66cg4yGZP5+HHf7VouXYms4Ua43ekgKgNz/xN6FQ6au1Rwa4AmfoCwB1zxI7AJs3+5UIeJ9X9s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from CY4PR11MB1783.namprd11.prod.outlook.com (2603:10b6:903:11d::20)
 by CY4PR11MB0037.namprd11.prod.outlook.com (2603:10b6:910:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 31 Mar
 2021 12:51:25 +0000
Received: from CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe]) by CY4PR11MB1783.namprd11.prod.outlook.com
 ([fe80::6dcc:f099:6ba8:6ebe%10]) with mapi id 15.20.3977.035; Wed, 31 Mar
 2021 12:51:25 +0000
From:   Raoul Strackx <raoul.strackx@fortanix.com>
Subject: [PATCH RESEND 2/3] x86/sgx: Fix compatibility issue with OPENSSL <
 1.1.0
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1617194795.git.raoul.strackx@fortanix.com>
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
Message-ID: <1b0e22f0-1639-40d7-e860-0d6f2c97d341@fortanix.com>
Date:   Wed, 31 Mar 2021 14:51:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <cover.1617194795.git.raoul.strackx@fortanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.164.43.210]
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To CY4PR11MB1783.namprd11.prod.outlook.com
 (2603:10b6:903:11d::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.101] (81.164.43.210) by PR3P189CA0052.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 31 Mar 2021 12:51:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1755689b-b22b-4ed7-fe0a-08d8f443b174
X-MS-TrafficTypeDiagnostic: CY4PR11MB0037:
X-Microsoft-Antispam-PRVS: <CY4PR11MB0037AFDEE342B08A75D57DB58B7C9@CY4PR11MB0037.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VwRusuJN54tdl0/R7cQF8Co7Vs1bBC7XZWRioqaoQNb1GkpV8vBvPXIdr2qQ+FaT3tcyAG7dmXAnrKxNZ8EPWij3YkXogqhpWaQptiP1HBecpqPycMQ7XKfaR/IO2rvsw7s+3sImPbvVVsDln/SH2gRappTvksoKYEjKN1nHTHP/YbQgmBltx+vALzGuzxIhGWcGDYQF8U6ks5PyusgnIGSoHSwhKy518PVzhFEzHX83/YHjVgkAwPMSxtXLo5ZqDkGBKOfwgKwdyI9pNk7S20nA/cIMgv6Xbs6qOX4R4KCuqc8IoUN10e0zOtwmqA+2xWxuFkHiEmu/JmKIMeOBrbrxrC6hN5axiYLGK9qpv7tFiHjLPaDt5zsxYJSNHeZ6VvVVacauWvGC6vjNcDAK6+64ria0KikYEkILpQS3YXl8427cwO4oEXGQRunnp6CxMBeL0I8I4DGCzLuXDJSL49BVbuq0WCSgw9x2fPcd43wZxuoOa4X5v3RVZ219q5gBZzZ82qMwv6XkLISxKD7j/gC66tUJxBISohhUf1Pxo2WbyzWFtXveppFpU/6C8Ggok1Wh/5gMSIMkfrAVorDrfru9ZOr4ZjSDgJFG8sx7eb+/Y+tIgRhK7g0i2p0PC4b+vmTG1jDUHAoC/01ZOkOOQPd1B9mbTezCETKyH47p9EEZ7BUOhd4iVyCmUgdtKpJGSyyazBg6JlI0ASbp6yzNtAvbhMKHhv/GwFlO/esVDzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1783.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39840400004)(8936002)(110136005)(2616005)(44832011)(6666004)(8676002)(16526019)(26005)(52116002)(83380400001)(36756003)(956004)(16576012)(31686004)(38100700001)(31696002)(186003)(2906002)(478600001)(66946007)(5660300002)(66556008)(66476007)(4744005)(86362001)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R3ZVZVp5d2NoYUlCeTVtUkl4RndvdkthMHM5aFgwaHM0ejY1NTdzaEpqVVBQ?=
 =?utf-8?B?c2kydU51L2tMTGdnQysrbFVjcUc5NTJXTFhsbFUySDgxdHAvSm4ydDZyaCsr?=
 =?utf-8?B?MC9mRU45WVFrWmo5bVpRVlA1bndzRThMUWFmQmhqR2E5M3NvekdZWndTdnd3?=
 =?utf-8?B?RHFLS3M4M3VzbW5IK3llbjJyRHdSSTg4bTdIektMZTMxd0Evc3NQTnlBZjFa?=
 =?utf-8?B?RkI0L2pETkoveTZZdW1XSUhpb3F1eEo2V1BKbXJFRnREZEVFWkxXTGRWZXhZ?=
 =?utf-8?B?L2JxT2F4M25qalk0T3pqQ1RacnRRZzljVnM5MVJWUzJIdW9OYytRZWdDdkNr?=
 =?utf-8?B?YTJxVWZneThvTEZWUkNmaFcwc1lPOUt6b0plZXNrQzhJeksvYjNFNXVTVjZJ?=
 =?utf-8?B?S1QzdWtiTXROSTEvOTVOMjFFOTdBbklVNi80czdlOFhYVHZNZmhlOU5Rd056?=
 =?utf-8?B?RzBrSkpBMUVJL3pHQkZvTW94WFlBLzJ5VDBhZm9OUWVLdVdCazJicEFlQVBi?=
 =?utf-8?B?SllLVkVEM1ljajVnQjFqVWdINkpKVEVOSHZLUWdKcFFsVnN5Z09KeEh0a2l1?=
 =?utf-8?B?Tmlna0Z2Zm84TnBBMjhQS0FMM2JBVFpmYkFVUktsd3VDZEZUWXBseHBwN21a?=
 =?utf-8?B?Q0tUa1JzKzJKMmxsVit6QkhRcHhhUlpUSzllZmxSTTcvVjlhaW4wTVFVNTd4?=
 =?utf-8?B?eGx0QkhBUnNCWDEyMWZvbUp3UjdjS05zeGJIMSt5STlCT3c1bFprQjlDM0Nl?=
 =?utf-8?B?YjhtVUlGZjEyTUJrMnVTeURjY01sWHI2N1FoaUVrMGJXTXl1NmFtOTNBa3lZ?=
 =?utf-8?B?bTBCdXBFWFNJZDlWL3ZCczFWeVREL09ZVDc1cjU0U2pVSnFjaENKaWtRZzN0?=
 =?utf-8?B?dExObEZDMzU1RlRuMm1vL21PQ0E5Qy9jTWpMcnBFbGlFczF4dUpmdzcrMlcz?=
 =?utf-8?B?aEtYSHhqVUJpWS8xTTBtUlNnWGZxa1ZCQzZlcXVKMzBOaXYzMXc5dEdySW1W?=
 =?utf-8?B?YUR4UkxZQmRIRlJHSytlK3hnN3RIWTVaaGlIQzZzWkZHMFVQcmZOckRmVS9J?=
 =?utf-8?B?WHZKQWFLMEhYQWhtL0VLUDJva2V1VitHbUp1aW1vQU53b3F1QnNlOSsyd2RN?=
 =?utf-8?B?UWNIRTRIWGsza2lpQW40OXA2YVFHblcvbE5lbUtOUFliaHNvdE5LWmZvUnpD?=
 =?utf-8?B?ZVM4R1U2Uk5hbWhydEpseFFtZHJ6dnFad283dGk2Zldjd2VRT0ZwV09MdDRV?=
 =?utf-8?B?V3lGMjBhNXhmbWRBK1p2VFdSNzlla000WXBRdW05NDN4ZW5oRzhvczBKRnRH?=
 =?utf-8?B?cWhSTC9Jemg5V1hsUkZHeUphQ1pOL3lYbGhzYUFob0VhaXBjVUtrVFVVWkIv?=
 =?utf-8?B?cENaaSsrL0h6NzNBaS9WRzVkQXUrRC9sVk90WkFCNjZ4MDdFNHRmZUdabWRM?=
 =?utf-8?B?OEJOeTkwcDNPS0Yxc2VkM3pLcjk1QTlaaHB0WGVNT21lWHVBcjhJQk15QzYz?=
 =?utf-8?B?bkFMWUIyYys3RGZTbFVLU3g0aW5jUXZNWWFWSHNiQmk5Z21aQ2tXV2tUTUhw?=
 =?utf-8?B?V2h3b1dTMTdEWitMa3UrWHR6TU5HTTlkZTlDdHBIQnFIMm9SWFFjcHh5Qk1W?=
 =?utf-8?B?cGJNYnVCVURxQWFDNzMzWGpiTm1NM0tGajI4Nm5OZ1dPWWxZdGExVHNXdXBQ?=
 =?utf-8?B?aWNsQU5jYm5zdUFzTWVIN1dZcDFidkp5dWt0UVBwR3F4Z2lnb0phVzFXeStj?=
 =?utf-8?Q?T+gUcFAGKrYHk65OLcVv5MJxXH3Vrw9FZy5CUX/?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1755689b-b22b-4ed7-fe0a-08d8f443b174
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1783.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 12:51:25.1395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cp1jQIXHAPo2epWXhvKgRkaqXa5OjtZ+ia4dhrWLGRA/gis28jUQm5N0geOOE5hVkk/vBZ3uCIBH3iprqSowE2pME+iRmsMIZ55FmZ9iSaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0037
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The `RSA_get0_key` function only got introduced in OpenSSL 1.1.0. This makes compilation fail with older versions.

Signed-off-by: Raoul Strackx <raoul.strackx@fortanix.com>
---
 tools/testing/selftests/sgx/sigstruct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index dee7a3d..aac9cbc 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -128,8 +128,11 @@ static bool check_crypto_errors(void)
 static inline const BIGNUM *get_modulus(RSA *key)
 {
 	const BIGNUM *n;
-
+#if OPENSSL_VERSION_NUMBER >= 0x10100000L
 	RSA_get0_key(key, &n, NULL, NULL);
+#else
+	n = key->n;
+#endif
 	return n;
 }
 
-- 
2.7.4

