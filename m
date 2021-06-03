Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F25C47096
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 14:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75968613F1
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 14:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFCOy7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Jun 2021 10:54:59 -0400
Received: from mail-bn8nam11on2128.outbound.protection.outlook.com ([40.107.236.128]:51296
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231849AbhFCOy7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Jun 2021 10:54:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKynG0tJQatkao28VCz8JQ5tRRjMQLC5zG2Ed/6De+rotJr2+niOsrCSeG8b3XtrSnM0jloePDOKsGnIQmmbVKVAQpcrV1r9Z+sVqD0v2adCXh8ROoOt9pbJgadTWQkER6TywC7LWrLZx5IoRjaof3+eXy4pIzBnuJVIGPBuToKMMXE72iZDVhPPdN60vR4cDsjxcgFXn2WcboFkPD351ydfhGCSvbap379X0TPgwDl/8rGCFH2ePnZEipOzCyUEmsjb34KsD7Cbe1n/l2JIn5n+uxIcXnKRGkQWmcpXGS/9M1vcF3DMVqJwnhoWHA8wNPWaOR4xTRl34dds0Z06Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSnoXi/7AleDFuA/A7Sx5rXNh9VBwW/yvFKy+uldGZw=;
 b=NvQl7Y7osSM/i9BhKUx4oTaztVhMwqgdSoeHZ6wTIGgYLAqqbqZzZFxlUhgc3CHaBryY/Juz8ao89dgDtjWXlcm+0SpbJRWyh423tylSuAqc/08HiHvS1cD8wpiMNH+NtVZt44ONnIuw8pOUTFfTRDEw3SqLvcmsACHxhLqU+VPoss9s5MiOFQ8fcxe2zYbfoT4CYjDOqhWSzVgZv7Fm9/XTnDBxu4Pi6eBhEq7mQuo56ZKOrZwBEiZ6EmWgmMhNOkAULOVMjrmbiJt0+Km+nkrHyISVJNdATNcN+sLSXUxUk6IM88J/pfx9ZiFU81K696V9+tR030MLFH+rY2WJYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSnoXi/7AleDFuA/A7Sx5rXNh9VBwW/yvFKy+uldGZw=;
 b=rvmeS4Wot3LvbIDQLsJrOGH6E5zLx9AG4OwIBHAJWQbHr3JnY8qEbM2c3sRpecN04zZAUmr5/FkSN1fBlUSCZO+KnhT4xYPce3SUdmI5bnLDnQ87un+vPzVTh0X5rcwV99XK9foW5ju6QuQl7goHng27IhuqBCf4ppIP4c3g1/Q=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by SJ0PR11MB4877.namprd11.prod.outlook.com (2603:10b6:a03:2d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 3 Jun
 2021 14:53:10 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::7475:f949:f6ce:b11c]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::7475:f949:f6ce:b11c%3]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 14:53:10 +0000
Subject: Fwd: [CFP LPC 2021] Confidential Computing Microconference
References: <YLjsd7zskBPaN9C6@8bytes.org>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>
From:   Jethro Beekman <jethro@fortanix.com>
X-Forwarded-Message-Id: <YLjsd7zskBPaN9C6@8bytes.org>
Message-ID: <b412f5cd-11b9-8c57-c0a7-e23b73c2c02e@fortanix.com>
Date:   Thu, 3 Jun 2021 16:53:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YLjsd7zskBPaN9C6@8bytes.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030408010203030102050208"
X-Originating-IP: [213.127.124.151]
X-ClientProxiedBy: AM9P193CA0016.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::21) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.124.151) by AM9P193CA0016.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Thu, 3 Jun 2021 14:53:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0adedb1f-5091-48d2-2582-08d9269f4de5
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4877:
X-Microsoft-Antispam-PRVS: <SJ0PR11MB4877AD0A2A3E0345357F8DCCAA3C9@SJ0PR11MB4877.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fyVwpHuPIeo2QVLQdsvgBVyGlTCSTMMVcJn+RUMMjpSDnwc+Q1SS+b5z0uGzCIvTJEZV6hGy+qFaMMO9X/PCKl1N+bHYjkflxVg2k7VzUzBOuqdSm0MNa/3u4PWZar0PEaQyuOxSspMhDBRO86FwPJhTCmFqiCec3rFlqrYA5u49RJ1GffykYVUZsRxjamN+VA7PB4NdfYrfvAEnR2840r33vEarLgg5KxMmx4n7fAJUu8AW2bGQQ5aMKj5pN+4zL6hv/GrzGQaMPLS1Z79xn1RfNvpl51GeYtVvaXqXUmpxgO1UDTKEkHAt0ZXYaIaHFodA5jWlSP83zJ0o04mTUVDYem2odsVUS8nP1Pay0kP9DOpsw2H4gs471EhcJG3CPmL39H281uucZX5JOfE1OO8rJMJWQy05fwigug+LGBPG8ETtnoHQOJBF/3YFJrGqfMR29A8ZrRCt473ewCNzr1YTQ8tcUr41J0Rr9wECW2zPlpBiodbUSWcjXP8xlnqgmvNJY9JHP+Eqr11MPiiQMPdzug7RreeTyxLjeztAhfQO8qO4gHdLUvdHEGlR9VApE22mLSeVp86TmUofQVHYxuNJqfL3SfPlSPWk3eujy/SSIDCS9gfkDk8hOJYMutcz88dTR8ArnRuFqtEaWB9CvVzCYPSp/fla70vwXseug/bXf8pVKmyZV+QBw2zWjrFwglaf3B4eQ2YLRaWdN/ABt37sYA2/0P8F7bMZanu82ElEBTh8lycXuzVnssRfP2+CWWYZgLzi9I+Jso9/cHHdBjWJ67K7AAh4IV8bcMSLyl7pM4bviEhA+7NQFjjw2buitBIkFy+pCUQo0j/fj/v8Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39840400004)(376002)(4326008)(36756003)(5660300002)(6916009)(52116002)(6486002)(31696002)(8936002)(38350700002)(38100700002)(86362001)(6666004)(8676002)(235185007)(16799955002)(16576012)(956004)(478600001)(66476007)(66556008)(16526019)(186003)(2616005)(26005)(966005)(2906002)(31686004)(316002)(83380400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?8VMNhnufc2+xhpMzyqnNgWuSYWj6PYfv7yBA5Y+WSUaUQ3RKUoiTeDJZ?=
 =?Windows-1252?Q?3kPp6JvDiQILG0aYiGIbMkfk1GQlyiMXqkcdF+0AWis23HUPgJGkuJ4B?=
 =?Windows-1252?Q?pn+uzN1ne1iG84MaIDJsHr7D8q77trkfWZXWSdRiVxIrTi2faoc0BDYl?=
 =?Windows-1252?Q?pHOkZJUK+UD7wcvQQxeQNP6v0SJsN+LGBgMfU0jlr1fHTPikdt37IXM/?=
 =?Windows-1252?Q?Eh515Zd/KGZHDLbN6H7qxB1mZKgbzjdivxXcay26LXz1w34fZ1pgJ33D?=
 =?Windows-1252?Q?PgdaDm3xdJKsnLa09qvWx7dcpLfpzSmr7jGLY2STFpEGogIKZCC5iqJe?=
 =?Windows-1252?Q?Oo6YL11vnP8oZR8OWufpLjil67tylCYydrL9+2A4UzJSmYVuiiqREm4p?=
 =?Windows-1252?Q?9mGz9VlGSIZ6orObXlcoYti6RVTZN92jRUqZFQFoJht5Xtlkw7+nUP00?=
 =?Windows-1252?Q?p6JQTpg+gjlIT3k+WxWNTfPvhF/NROflCEfo6giuCJS0KMzsavSnH290?=
 =?Windows-1252?Q?Eum1UJsORi8BkvFEmCQ9wH94J/vHEpknb/JGYoW03aNO9QP/Tncif3Pe?=
 =?Windows-1252?Q?KAf0tXydY/y1DpmSxMIVLCNz/XXL4q3RizJZhf+4DWoVer5Gl1KVePje?=
 =?Windows-1252?Q?Tv9nkQX1tsxHk/bjb3KRKeuOGztx1F04Uh990GvyH9kDwL/akPq2PajL?=
 =?Windows-1252?Q?FBqTTQTlVsuA97HXzlMDaLf7JCky99XW+y58ntzpmXdn0S9hRI3zz2I+?=
 =?Windows-1252?Q?IIYyPHsDZmlMIjovvmsN9nMK1TTBNQ58AnBaeC9kLELeYdzKzjxPpVzk?=
 =?Windows-1252?Q?ZPIUuk8vkKfQeyK2KSdDKQEVChq9VVJv747NHl1JUo6CatLgp9gk0m+g?=
 =?Windows-1252?Q?H6rzSX6QKxhkrc2i/vfBVna2Mz16J07MNB9Om6et9NKP+BdenqtSH2O9?=
 =?Windows-1252?Q?KzyE/NlMFYX/zojI7Dt/KZC7Mi11mM2Ctn8+NUZul/4ThTDEhVeM8KRU?=
 =?Windows-1252?Q?x+OVV8QOaj/RW2KWsrNBAwGuhd5HkaKCqZt+a+ZtF8t8FenZUAOTi+Oz?=
 =?Windows-1252?Q?nIqJFVOpQDLxkuWU9iugw0vhtW9Tbw2nigTX0VtK9XJH/LKN0NvoziB5?=
 =?Windows-1252?Q?ommqTpF8LFU5THNokDZRO7+u+xke8TSxVYajXSgUclR1eflJ8YTSFq/A?=
 =?Windows-1252?Q?FsikFZAQHmTYfAXT90lYky0xCmCHZRRGrntbveQuMSAxj5L4rizyHVS4?=
 =?Windows-1252?Q?qahW2hUsxM4GiBh84SGEy0LuSSFuZqKBMSrja2Omj/2rtCJz32hcVxa1?=
 =?Windows-1252?Q?y3ZQ8CXwoo3YqcqEzj4+vKcQAJ7ahW4ASRuTBmgNW6fW0xVAwiVC6H0W?=
 =?Windows-1252?Q?y9qhlx1JiIFOphErMius81bxPRb3jhrD8wvOd+VucQvBVeHF1TJ6r7HM?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0adedb1f-5091-48d2-2582-08d9269f4de5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 14:53:09.9453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajOncJYz+hSSiR3kjX9T2g2bZPkMiFnTZVNDqu2elk5MA405d4RWPUqOiAgrwBLNxGihzfdFTTGfswhbZGYYGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4877
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms030408010203030102050208
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable




-------- Forwarded Message --------
Subject: [CFP LPC 2021] Confidential Computing Microconference
Date: Thu, 3 Jun 2021 16:51:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.ke=
rnel.org, virtualization@lists.linux-foundation.org
CC: Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, B=
orislav Petkov <bp@alien8.de>, Brijesh Singh <brijesh.singh@amd.com>, Dav=
id Kaplan <David.Kaplan@amd.com>, David Rientjes <rientjes@google.com>, J=
oerg Roedel <jroedel@suse.de>, Jun Nakajima <jun.nakajima@intel.com>, Kir=
ill A. Shutemov <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzin=
i@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sathya Kuppuswamy <=
sathyanarayanan.kuppuswamy@intel.com>, Sean Christopherson <seanjc@google=
=2Ecom>, Tom Lendacky <thomas.lendacky@amd.com>

Hi,

I am pleased to announce that the

	Confidential Computing Microconference[1]
=09
has been accepted at this years Linux Plumbers Conference.

In this microconference we will discuss how Linux can support encryption
technologies which protect data during processing on the CPU. Examples
are AMD SEV, Intel TDX, IBM Secure Execution for s390x and ARM Secure
Virtualization.

Suggested Topics are:

	- Live Migration of Confidential VMs
	- Lazy Memory Validation
	- APIC emulation/interrupt management
	- Debug Support for Confidential VMs
	- Required Memory Management changes for memory validation
	- Safe Kernel entry for TDX and SEV exceptions
	- Requirements for Confidential Containers
	- Trusted Device Drivers Framework and driver fuzzing
	- Remote Attestation

Please submit your proposals on the LPC website at:

	https://www.linuxplumbersconf.org/event/11/abstracts/#submit-abstract

Make sure to select "Confidential Computing MC" in the Track pulldown
menu.

Looking forward to seeing you all there! :)

Thanks,

	Joerg Roedel
=09
[1] https://www.linuxplumbersconf.org/blog/2021/index.php/2021/05/14/conf=
idential-computing-microconference-accepted-into-2021-linux-plumbers-conf=
erence/



--------------ms030408010203030102050208
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
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMTA2MDMxNDUzMDRaMC8GCSqGSIb3DQEJBDEiBCDF
PrL19gnMu7qWoUhbab4wIyI7Dh3RhsulbFex98VGbjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBAN7mwlyPS7lqT148jXKwZ7dXIHEvYknfTUppfFU4GL+MtPBRq0SD
9nUgerD/7gEVU8pwkXbiSM47FNoYxsw+j8hTqmEcmFUnodVH1WeZmeyTBeK4iNuxdMZB/q20
nmlg256SQ40eumEwXPyl9QWK04NUrQblS4wRBJJ8tOZiv+AK0bDMPY3OlTVdP0p+6DvsCFNN
frlFiXltN1NpDHW558W0OBaZf8+dspLU+JInWu0KUgO638J6rlGOc5aPORvvyi+M1LRvcBNy
yK4dL1y/rEh/pf+uMIeQmgOd8G1FrGk2o9rKmMRORV/fGykxt1pACyi8qZRzZ9DrKaNITwoB
aW4AAAAAAAA=

--------------ms030408010203030102050208--
