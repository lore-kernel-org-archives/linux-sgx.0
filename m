Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69189C48BE8
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 08:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34157613B9
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Jun 2021 08:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhFRIrB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Jun 2021 04:47:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:15420 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhFRIq7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 18 Jun 2021 04:46:59 -0400
IronPort-SDR: EVivylnQxRdnpYpEbY6h0jKKnzUXjDZ4snQvo4NHdx25zrKpXbVimyqbWWgJ+TP45RvOTdOpsX
 Ns4zWwiRqbzw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193650183"
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="193650183"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 01:44:49 -0700
IronPort-SDR: CA0SjgQpATT5304meRYT5Eozm86oR8cF2q3VQ5JQKJ32WzyboeUmyDsrU7H0HmIDd0og1cjLeA
 Zk5jrLN72kig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,283,1616482800"; 
   d="scan'208";a="451315494"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 18 Jun 2021 01:44:49 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 18 Jun 2021 01:44:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 18 Jun 2021 01:44:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 18 Jun 2021 01:44:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VarnH0BXbekmz5auDTAVHzl1wZ7DVZ7s631qM+hq22rw5Oqe80dVlcir2fvkfw6yR6QaF/eXJMUm3ZSrkjSCP7QkW4zPAYNxbilpKJaj+Da6crF9ZBzZhd6DewCgkxTzO3P07rjAzHIOrc27nUn8pZhVVBiQy1OjyJ/83UYReYTdYI7R6YGB6tuKMOB6AFwlawmuBiJeo9WxzO0r49jrt45sFqnZnFBJ9zQeCPDSvEF2aNcUCVmL51GxWl5+968hYrnOCXGBQZBSy1Uj6F1qKyFbTCUIIZ4dJRyTfharsNGzevPdqolIaSF59uM8e2qluf3fNmPVW+0pgw7T4SHQwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeMNYN2y5sdYmLEfkDM0Cp4pHIZkOEcARN52gJnGkFY=;
 b=KZTV0+/rJd9nGD+q4q0SVPPmgyxEvOiYmLXmOF1rVIXwbQOLfM1eCWK8H54J6n3ysz5IgVtGrBDQ4IAwZ3UNMZ8AAuy3FfIWo5mWFbdjs0/GjmqthONY2nF/H/jQT0GtCkEPhgwgr7AwbpR8IrcQDK6uJJRfjlgjweuYIJJIOJCovHkjg5y4egJdywZM56Zt/xeEq9UdXTMP6Y4Vdpl/uRbxuub+z7nq76crOgRr/AqbKBD+7IsR7+X7Lfo5PKyotQxuWp2PN8qONosLaYKD9IUDMS0KDEB0qTHNEXgrCbNsyoElJ6TBui/0LB3o2N1rZCN1znrgrIvgjHD2lvilrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeMNYN2y5sdYmLEfkDM0Cp4pHIZkOEcARN52gJnGkFY=;
 b=rAnfWM3Sgf+2JXWF5R0DTsUQ9+NcYIG5as375D2OXoa3tidRFZcWxClrpVJImbvsaeb4KRrotJMHMyfpuSDzHb1fbUd1LNsPb3ndCdTNeXGbruqPk2qGhOmZ4wLQIXQQ0s2s0TyOEH9n7mXaibblgaFkSmBYa3c7aSadSiuxWgA=
Received: from DM5PR11MB1595.namprd11.prod.outlook.com (2603:10b6:4:c::14) by
 DM6PR11MB3979.namprd11.prod.outlook.com (2603:10b6:5:197::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.19; Fri, 18 Jun 2021 08:44:46 +0000
Received: from DM5PR11MB1595.namprd11.prod.outlook.com
 ([fe80::d4a8:cf17:6151:3179]) by DM5PR11MB1595.namprd11.prod.outlook.com
 ([fe80::d4a8:cf17:6151:3179%9]) with mapi id 15.20.4219.026; Fri, 18 Jun 2021
 08:44:46 +0000
From:   "Du, Fan" <fan.du@intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH] x86/mm: avoid truncating memblocks for SGX memory
Thread-Topic: [PATCH] x86/mm: avoid truncating memblocks for SGX memory
Thread-Index: AQHXY7GdfM66nbFd7Uilf/FXVgoXGqsZcjyg
Date:   Fri, 18 Jun 2021 08:44:46 +0000
Message-ID: <DM5PR11MB15957710871310F9CEA14EFA990D9@DM5PR11MB1595.namprd11.prod.outlook.com>
References: <20210617194657.0A99CB22@viggo.jf.intel.com>
In-Reply-To: <20210617194657.0A99CB22@viggo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [223.104.39.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 297f9ab9-af20-483a-6b20-08d932355369
x-ms-traffictypediagnostic: DM6PR11MB3979:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB397924FEE9E06EE30EC115E6990D9@DM6PR11MB3979.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XRbjJHIuv58nYfkiFFnt7v6b37yqf9DpGEM1F81RWhDM7VANca6h+S8DRcf6cK1ChRiC2C2lq2uofCMkTuHDVbRLBoccI2me1jGKx3qYKWFnp4BOJhEa2mO258sJWvg8yf1xROYSPs44qUj1ZMfPpsLcvXTxIeCdyPwlozJmPkScPNL3JySdbEUy5d+OIad+tBce9bo9Ru9JBMhgkfRQLcN2GkVsddSuaqZBBGSOvUKDQMWU1ASZvjdFnc69qCamO+vT7u2mYtUni7EhC3quFzd36hax7zUVnONcafJqVNRUHjkmw3JvH+uWyrKYAAHGVIUV8uENtGeI/amMQRARMhEkWLEUJzM2VrSkqMM96T0wyBQgCAbYc0+VvpF0tPqLhMqvyDmkwBZ3AI4WeX+V0YLaBJLx2p87LkkUgTJfoQPJMsR0D9ATOwFTGTigSe0bR9gb6ymXHcKUDhWnWdrZNsLojezr/nO2DszIRFfbeshHbM2+uQDFiR8WhzlQwnK62twl4CK/8nnKk1CIXuddzEUZur3FUmJrS8/af+pWSSEUPPKiNLAIcfH1zWImpD/6WQ/dcOS1UrPz91McTTP2eYlB6Jd5WjFWRxyLtrBdn2VMl8sDxgvmHsoqFpkgRV7oNy4j9EAQgcjKsWPVTEMnFalXpcEga6M7CE+l9LQud+oz6ePmjoiW4V8NSKMlh1wxF7nz4Xul1RsTTIpiOSwqztngSDK99iaMFHmBdKfFKeI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1595.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(376002)(136003)(86362001)(5660300002)(7696005)(2906002)(66946007)(66446008)(55016002)(38100700002)(6506007)(76116006)(186003)(54906003)(122000001)(316002)(71200400001)(26005)(64756008)(966005)(8676002)(478600001)(66476007)(66556008)(110136005)(4326008)(8936002)(52536014)(9686003)(33656002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gZa6f6407xzymSLqyQqBsMI50V1Y3rfbt8PkItE7O4wQAb6lX/UzBifTtsvG?=
 =?us-ascii?Q?Ht5pyMLCP6Eh9IGXQQVj5bSOcP4yKu4Ovc/wqaIkjcODqWufJkx03bzB7DXw?=
 =?us-ascii?Q?BusUK9mDVpqfdWaoiX7APsrRzGy9IH4g8uHSHaEgL6hV5FYo9f0fOWoL9pLy?=
 =?us-ascii?Q?B7FtQWt3mbqW70/+QerOu17t0FQKdw+G4s1STp+2n3x2NtmiKbDeS1mDCRcT?=
 =?us-ascii?Q?r+7vnyFxDF6YCCHqSZS7xfAvA1MjTsTRnZ0Ssqj2JNfAN59bs6bfVyMj25uk?=
 =?us-ascii?Q?jVvS49rYWZSApjMY6LkxjS245N7G1zA0wCo78+TuGZthcB+aWt/Oa05I3kKV?=
 =?us-ascii?Q?k9oyeDcuNXy8o2sqmfwy6GbAxtaNYoUuw5zyKsBA6xZLgUPYXGeOv3o909UW?=
 =?us-ascii?Q?zK8oHDcElg6l4xTQwu9nnI5dVDZwCh+zksu2FYZAAH8eOkj13zGDhLqSQQH5?=
 =?us-ascii?Q?9edaNeGZbQ0tzFg98jGavaqqrKFT0tQt4J7a5GBMJOmwVW7mK+uXfyUZ8PtW?=
 =?us-ascii?Q?4M4wqa8fWF/lfJEbYi/tdkw6c38OW9x68OIdpyUheCk6jWJHfnyMJV2mSNUe?=
 =?us-ascii?Q?Y/EQ1Hf4HxmDO1Aeyx1a3x5e0+q6xOvjMPiZgvzdPsQFun4PEX4rydkgWKwR?=
 =?us-ascii?Q?/Be1N1rAqLJ/SO5H6NY3CdW9fRe15bpUSRIId7yzrhG+xQQbvD1WvDQbxky9?=
 =?us-ascii?Q?gqxHO22EthjVxTeZA6kqs2ZPnBNlvc+DNT4g905MfWAvLLanJxS88Te7NmON?=
 =?us-ascii?Q?S6J6wGOixQmc8kYs5aIslZleYzTeRJAA6CXinQmLe+O/ubW5vbdVR0CpCPUY?=
 =?us-ascii?Q?O6L6MsP5W6/lrIcxc50+XCv0wP0aKHnvDwcwBy0CUE3N+OVezfDEFha2QTA8?=
 =?us-ascii?Q?YMVLIh7Yd4yYG8WQ6F9uF8nn1gJJ/c6Ibrn/bFN4z75ssf+2izi1G7tWHhvo?=
 =?us-ascii?Q?+h1IzQrS1DqYmFmPxjoYSlCMqMUKsMNjRzk76pPmwNy5/Fs2+ap5sxTV+AOH?=
 =?us-ascii?Q?/XvIBbmCGu7AOm7Q3Gs6n0JZT6CteiUhqnT624bTBsCEvqnOgzyfrmxZ8FKo?=
 =?us-ascii?Q?5HlZd+Bw1C6kmX4gpfRjpOYgHtvk9OtLtVFrYNy4wmNGAuBzNbQeGdcNtHgq?=
 =?us-ascii?Q?EOdoFcsZJs8ZaNdDUbljFR0gdwCsmNip1Vg4E0lc83/BfrNc7GuG9i6zfcp0?=
 =?us-ascii?Q?KW6IwyNA/HyiaMxV7oilv9sfxK3pvHb3SljB3IxpaN6fDk6ecTAllpsT34bY?=
 =?us-ascii?Q?IqDtxptYweLcjdi3nJhiIJ1Um23BBb4WaTrkeK263olCkuUzXeemhMgwJpHs?=
 =?us-ascii?Q?N7s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1595.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297f9ab9-af20-483a-6b20-08d932355369
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 08:44:46.2349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TikuDp14XNB4tXvjuvh+Y0k6Lccey7x3eys/MnOpDfvUCp8CEYJXUEYvnOY1Y1FzOQi0mgzBgESfrfNRWPgZpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3979
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



>-----Original Message-----
>From: Dave Hansen <dave.hansen@linux.intel.com>
>Sent: Friday, June 18, 2021 3:47 AM
>To: linux-mm@kvack.org
>Cc: linux-kernel@vger.kernel.org; Dave Hansen
><dave.hansen@linux.intel.com>; Du, Fan <fan.du@intel.com>; Chatre,
>Reinette <reinette.chatre@intel.com>; jarkko@kernel.org; Williams, Dan J
><dan.j.williams@intel.com>; Hansen, Dave <dave.hansen@intel.com>;
>x86@kernel.org; linux-sgx@vger.kernel.org; luto@kernel.org;
>peterz@infradead.org
>Subject: [PATCH] x86/mm: avoid truncating memblocks for SGX memory
>
>
>From: Fan Du <fan.du@intel.com>
>
>tl;dr:
>
>Several SGX users reported seeing the following message on NUMA systems:
>
>	sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback
>to the NUMA node 0.
>
>This turned out to be the 'memblock' code mistakenly throwing away
>SGX memory.
>
>=3D=3D=3D Full Changelog =3D=3D=3D
>
>The 'max_pfn' variable represents the highest known RAM address.  It can
>be used, for instance, to quickly determine for which physical addresses
>there is mem_map[] space allocated.  The numa_meminfo code makes an
>effort to throw out ("trim") all memory blocks which are above 'max_pfn'.
>
>SGX memory is not considered RAM (it is marked as "Reserved" in the
>e820) and is not taken into account by max_pfn.  Despite this, SGX
>memory areas have NUMA affinity and are enumerated in the ACPI SRAT.
>The existing SGX code uses the numa_meminfo mechanism to look up the
>NUMA affinity for its memory areas.
>
>In cases where SGX memory was above max_pfn (usually just the one EPC
>section in the last highest NUMA node), the numa_memblock is truncated
>at 'max_pfn', which is below the SGX memory.  When the SGX code tries to
>look up the affinity of this memory, it fails and produces an error messag=
e:
>
>	sgx: [Firmware Bug]: Unable to map EPC section to online node. Fallback
>to the NUMA node 0.
>
>and assigns the memory to NUMA node 0.
>
>Instead of silently truncating the memory block at 'max_pfn' and
>dropping the SGX memory, add the truncated portion to
>'numa_reserved_meminfo'.  This allows the SGX code to later determine
>the NUMA affinity of its 'Reserved' area.
>
>Without this patch, numa_meminfo looks like this (from 'crash'):
>
>  blk =3D { start =3D          0x0, end =3D 0x2080000000, nid =3D 0x0 }
>        { start =3D 0x2080000000, end =3D 0x4000000000, nid =3D 0x1 }
>
>numa_reserved_meminfo is empty.
>
>After the patch, numa_meminfo looks like this:
>
>  blk =3D { start =3D          0x0, end =3D 0x2080000000, nid =3D 0x0 }
>        { start =3D 0x2080000000, end =3D 0x4000000000, nid =3D 0x1 }
>
>and numa_reserved_meminfo has an entry for node 1's SGX memory:
>
>  blk =3D  { start =3D 0x4000000000, end =3D 0x4080000000, nid =3D 0x1 }
>
> [ daveh: completely rewrote/reworked changelog ]

Really what's your PROBLEM?!
Neither did I ask you to send my patch, nor do I agree to change it.
Who grant you the right to do this ?!
It's disgraceful to do this w/o my notice.

If you have comments, please DO align with the other two maintainers Jarkko=
 and Dan first,
who already reviewed the patch in this format.

https://lkml.org/lkml/2021/6/17/1151



>Signed-off-by: Fan Du <fan.du@intel.com>
>Reported-by: Reinette Chatre <reinette.chatre@intel.com>
>Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>Reviewed-by: Dave Hansen <dave.hansen@intel.com>
>Fixes: 5d30f92e7631 ("x86/NUMA: Provide a range-to-target_node lookup
>facility")
>Cc: x86@kernel.org
>Cc: linux-sgx@vger.kernel.org
>Cc: Andy Lutomirski <luto@kernel.org>
>Cc: Peter Zijlstra <peterz@infradead.org>
>---
>
> b/arch/x86/mm/numa.c |    8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>diff -puN arch/x86/mm/numa.c~sgx-srat arch/x86/mm/numa.c
>--- a/arch/x86/mm/numa.c~sgx-srat	2021-06-17 11:23:05.116159990 -0700
>+++ b/arch/x86/mm/numa.c	2021-06-17 11:55:46.117155100 -0700
>@@ -254,7 +254,13 @@ int __init numa_cleanup_meminfo(struct n
>
> 		/* make sure all non-reserved blocks are inside the limits */
> 		bi->start =3D max(bi->start, low);
>-		bi->end =3D min(bi->end, high);
>+
>+		/* preserve info for non-RAM areas above 'max_pfn': */
>+		if (bi->end > high) {
>+			numa_add_memblk_to(bi->nid, high, bi->end,
>+					   &numa_reserved_meminfo);
>+			bi->end =3D high;
>+		}
>
> 		/* and there's no empty block */
> 		if (bi->start >=3D bi->end)
>_
