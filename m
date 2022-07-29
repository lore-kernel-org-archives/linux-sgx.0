Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD3DC00144
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jul 2022 16:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiG2QBO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Jul 2022 12:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiG2QBN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Jul 2022 12:01:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9366D357F5
        for <linux-sgx@vger.kernel.org>; Fri, 29 Jul 2022 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659110472; x=1690646472;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=Bz/TolItizD89xtkFAQ9Sa1RwOYluH6F+Yr7OtvKzW0=;
  b=aWdtZ45mognoGr1eObTFUzwEQxKqcYKzgvuQ6UHitT1OKHbYInMTHHhq
   7p02zZEI2sBIEmabG4p/Brx+q/gZjEGGLbE7Nh83ANjl1xY119RJP4C5J
   /FE8SspLpNituR4qAEyepO5imLe5uNb+SFMvwl8e7Uxz8PQHmO8hlSBE7
   t0O2PaqAOdQjMYpT6cjLyft4wTPqIIzBjHo2YT9WoOBW5CfmHy2RpdiTR
   liik1+NAGsPPwWyWEg4TA11ol6q7fk2Lf5tD4Z19tpKJNkvFEixQqaLeB
   2zAefYa/RJMXEyTwzDSIVaB8kGndD9VzpFX/wNSvlyHXCu2nH8MQC6A5r
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="288808235"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="288808235"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 09:01:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="576989294"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 29 Jul 2022 09:01:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 09:01:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 09:01:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 09:01:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 09:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzTmxlLvvJX9uyBPM0oqaLyCyyNYrPzCWPYQQKpYcEsmFg/4e38kCHB3BQYIFxukFV7jnqRjGDDfrYkn9frNzEMXKJ/0VAHP7ppxUpmGsxaA3LhUqk4viNr4ak9zEfy5eNBoB1msJarCUwvMQoHEj2a+LDeFnVNi+/5Y4beWppFjgrTyAU9oaUT3pjDjLjJuYJ2Ib2mXQLhXTVGY0Ehs0uS5eG6uN5iETd5WKJUJCJKNjM9xs3s7NMW8RRUIiJQ3ISIuhSyv7XNjehj5KdpDrw1KK1NM20AwFUlo7FdZDc9YtIRlJskz7uwewOD+jIVvz6v5vaRQa5VHaBZYGP5z4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aelZnfh4MdAI7V6CaP+4xAcztAcSUeq2VEJYtEHCtLw=;
 b=TGVjZ929W+gsBo3mbw6nyFJ4ojLcU8kknxKBBY0kVo3Cnc+hFqHb7ogp6SnYwiWwXMAaspduurkgvLKL0OUXlosm/ef0bwSCz/pnPk+vuWqjTQ4LtvE4dto61EWc44StZ77W7Y4PiR8Lb/uBw9/ZX2efwPwooF8YQX7/2RUixURYVAZjD2yi408H7GhwVGYLZyIHHM5VwkCE2D8U/ykRUyt2todJLnlpz1WIfBr7KR2xKuGsyjlz+ZgpX25IPGv8SP60PY65E6a5gX65lHq9ovOE7ZX8+OR87NmIo1fnU5/dw6F3AA7ScQioBy/b0nn0OP+jSjblae2egls0lorIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) by
 CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.10; Fri, 29 Jul 2022 16:01:05 +0000
Received: from DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc]) by DM8PR11MB5591.namprd11.prod.outlook.com
 ([fe80::b0ec:428e:d323:2bbc%4]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 16:01:04 +0000
From:   "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "Huang, Haitao" <haitao.huang@intel.com>
Subject: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC pages
Thread-Topic: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
Thread-Index: AdijZFc8mcX23sq9QFWgzapOaA5FWA==
Date:   Fri, 29 Jul 2022 16:01:04 +0000
Message-ID: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fbbcfaa-35cb-446a-0cb6-08da717b8ab2
x-ms-traffictypediagnostic: CH0PR11MB5332:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YYPB2x3vbL6O2VVCykS+wM7IH9vcti8Qgstab1AE/0MYoPxP35NwE6KNCoJKmUsmY7JYcH9TwONXwKXchgpnhYGsi44UiiDCoV0vmch4t89pOjVlPKeR+NBhN8Jpz3RDQKPI/ZDPUENHKNRHGhCDcNJWx7bWR7CZ9WqSLevpqtkPepKyYgjoaMjtiQ+Cs0VDhRsq455EvkYvKgbbe6JVYpP7C3K96h4rietL2s4/HRMiipRqM6yUq1h7vvLwyzNafZE69/6rjdAnJW675IopaV1ecyq5O3+uS95Otx0k9xIzeHIzVj/vEG7yi+RylCfFajiYldkSAA3hhLYghSOK7k1sho+47YW8zJzIN5Q9/AMViJQSfV+beSljJHiv9qrIgpagXIqkOr7BIMUqLprFmry0ZXmLWOKU1MLFL0Ya/MQozwrzQnCL8w+/nMSKr62py5xNkQoVL3n4OQvK8JxJ/MYCurpZhRK7ipn7u2kymD1TfKDFdOxj5t1o63hHjHGoIWPX7l1fAa1Swr4MzfNlpdtfISpnon1reUvu5reLfSIDsPSq8q0mBQJ4gG64AfLVk7EBmJHM5nIK1/u+JF0MjaZZrcp1nGBu4X/2jBShz2hjK2GjTkqJdeaWO4r3C2ZGn9N1/NYqj/iT31cg4DnaE41ITWpVvu6PK7FYJYyegoo2OEFI6w71b3p/YYSpq6xjmndIynKfkomtKu+BI//ijk/yOgVG3twsO0EtKQFua/1UOlBeuMWm3H5AJKc+HKZD2gFtL14MbWga7uHfIAyuyP8/7gkR93VeWB1Gp8zNjDOXx4GTzaBGGwOCw+DqWmlu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5591.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(39860400002)(366004)(396003)(5660300002)(52536014)(8936002)(66946007)(66446008)(64756008)(4326008)(76116006)(66556008)(66476007)(8676002)(55016003)(2906002)(83380400001)(38070700005)(33656002)(38100700002)(86362001)(316002)(122000001)(71200400001)(110136005)(478600001)(9686003)(26005)(41300700001)(186003)(6506007)(82960400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p47UeJIhvey0otX1ONhS/Nh5KsufPSwiI3azeJq20U31Pgl3McQAG5UOtjYd?=
 =?us-ascii?Q?ZgXoBRHQ53HNv3tHMHtavwi/NXD7VlVDngRbIOOUNFk1YMjA7By24fN6uQqw?=
 =?us-ascii?Q?CmtNMc5oQlxthndYR8dcZcYXYVN4GOUnCoh1QAIgJUHML6mKWaplJmS/lr6N?=
 =?us-ascii?Q?4zcapFLwmjTFw0BvmG+FatcnnYfMv97CrIGQ1I3XN4yQI6LKvyEmKbiQw89b?=
 =?us-ascii?Q?kBvOgaRE8oJEu353LFgz7MLKAGTT3waPtRS0WQ/c1YAGON6sGv1c0H1fmywr?=
 =?us-ascii?Q?tb2c2RcvUTF6+tuF9vFztAP7NPDHq45M3SZS0+uwZCeEmWRkznvQkqUWjQo8?=
 =?us-ascii?Q?gk9WIMRcQyJBZNY+bdWjK1N+Hz17jJkx5Jpl2OGc/hgIKYobxgry1SKRb4lf?=
 =?us-ascii?Q?zbR5Vb7PLj1CGTx1mH1eoKLxwWulrSanT+1+Nhb4vNwgSzc/Zvw4EWWWMZnS?=
 =?us-ascii?Q?CdA35G9RD66LtxGzZEcl0TYWS5LLLdEQa+Aa4lbUFlGjIhsHP9+c3mq1qSqb?=
 =?us-ascii?Q?BbHuQGWgbZbH2L+wkHZdDIwNAad2+rXgk85b+KRxabZAB4Edg+dxonULOCVb?=
 =?us-ascii?Q?kAndGn2uFpE6iuuC5axcLmSGWDCqeDPMvSuOI1l/6/dQt9Cp3WPJh7KN73l2?=
 =?us-ascii?Q?ZqabGh4Vibyc2ktpr2/CrawYR0vsb9aaNt61PIiYOcSWUxb/duIzKWbMaTUq?=
 =?us-ascii?Q?IFOMiFYP84nRmkjn2XOjY99cVM/wArJZlOBT7EP3OvZb+G3GaizehkgZq0QQ?=
 =?us-ascii?Q?StVQ5BEDCzqURq+8qXO7CSXAIJUtn5CUYyuFipgI9Iob85dkqRDjKGmS/TO7?=
 =?us-ascii?Q?2/2zZToZOAyZZqr9jsOgxgawVfV9ljgqBob/rYU1PT7pmvAwJerILoSnDOae?=
 =?us-ascii?Q?MhF6lk0Fg5jHyLJqQcp6XhEk9jx+nH6SotfMEdgH+5FlLkB3jDlcwpgTbxLL?=
 =?us-ascii?Q?1YBK67GoGax6dtHnz5rAp2C4T/eQy0uh3LFv6jIUkkNx0V8ezpADCd7Mjlur?=
 =?us-ascii?Q?M6EFHFTCsNa7L0cnKk9UZxV45gq7/se7qvI2yfmP58hUVUni7TlawmZQLcyM?=
 =?us-ascii?Q?OYzvbMUphEeKYbgU54tjNBu31+t/I8PuWGK6Nri0Setp9npsyDorJsay56qo?=
 =?us-ascii?Q?T4fmVwq0SpvHSpUwZYYJfZe2xh5fQtaV/V+7WYTZFGKbj4vtS2mkFfOW83vx?=
 =?us-ascii?Q?RiE/pGUK7A6262xKwYT5yHr2iO/IjRFGK108RrCXLBAf0FiDe3vM5/CgPPge?=
 =?us-ascii?Q?T//wDpiGdBfPQjNODS1tWjw/Xb7ANiP6CLMxC3b++cxZcSzlxVSXYORIfF4q?=
 =?us-ascii?Q?FGPjveRpoG8OmkuyrZRn5vWS6m+MAe0WWG/h1C6WsC/loaTQDEs4GWAD3YqK?=
 =?us-ascii?Q?T4NpH1OyKfkf7EU6DYJQzg91c3BqBDhKDspAvZghy0Bde9VbW4Ahdyacld8L?=
 =?us-ascii?Q?hh3soP1TM2MM05CdwtjOjAZ5MPpbKzqv6OGw6/BNoEUWmadCVjxtfU1vxJTv?=
 =?us-ascii?Q?rAxLyK34+23fBMl/zEmULKbHMhkqZOOyLSHHDZI/or0C6wThJhDakj3a6tcI?=
 =?us-ascii?Q?PwafuIleOVjLxC3H6wwijp6Fy+xaiwHV7U6iDVVG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5591.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbbcfaa-35cb-446a-0cb6-08da717b8ab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 16:01:04.7718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /P7UF3Dz+crWGVyH5BfSz6h5K/WSxutugOE3L8gnbrWkmJ8SwJP8tS61bsZCOLBxEDk1HsOw8A/dBhLhOa7uxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5332
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi All,

I recently tested the V5 version of the patch with Gramine and ran into a s=
eg-fault during EPC allocation that is `EAUG`ing via `EACCEPT`. Allocation =
worked fine for smaller requests and even up to 2GBs. But when I tried with=
 4GB allocation I got a seg-fault.
Huang, Haitao and I created a simple patch to repro this issue using the SG=
X selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot r=
epro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue or ke=
rnel, can you please check?

Results with V5 using modified `augment_via_eaccept` test:
#  RUN           enclave.augment_via_eaccept ...
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 8192, seg->s=
ize =3D 8192
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 12288, seg->=
size =3D 4096
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 36864, seg->=
size =3D 24576
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 40960, seg->=
size =3D 4096
# main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
# main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each =
page of 8589934592 bytes may take a while ...
# main.c:1184:augment_via_eaccept:Expected self->run.exception_vector (14) =
=3D=3D 0 (0)
# main.c:1185:augment_via_eaccept:Expected self->run.exception_error_code (=
4) =3D=3D 0 (0)
# main.c:1186:augment_via_eaccept:Expected self->run.exception_addr (140106=
113478656) =3D=3D 0 (0)
# main.c:1188:augment_via_eaccept:Expected self->run.function (3) =3D=3D EE=
XIT (4)
# augment_via_eaccept: Test terminated by assertion

Results with V4 using modified `augment_via_eaccept` test:
#  RUN           enclave.augment_via_eaccept ...
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 8192, seg->s=
ize =3D 8192
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 12288, seg->=
size =3D 4096
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 36864, seg->=
size =3D 24576
# main.c:1135:augment_via_eaccept:test enclave: total_size =3D 40960, seg->=
size =3D 4096
# main.c:1153:augment_via_eaccept:mmaping pages at end of enclave...
# main.c:1167:augment_via_eaccept:Entering enclave to run EACCEPT for each =
page of 8589934592 bytes may take a while ...
#            OK  enclave.augment_via_eaccept


Test Patch:
diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/s=
gx/load.c
index 94bdeac1cf04..7de1b15c90b1 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -171,7 +171,8 @@ uint64_t encl_get_entry(struct encl *encl, const char *=
symbol)
 	return 0;
 }
=20
-bool encl_load(const char *path, struct encl *encl, unsigned long heap_siz=
e)
+bool encl_load(const char *path, struct encl *encl, unsigned long heap_siz=
e,
+			   unsigned long edmm_size)
 {
 	const char device_path[] =3D "/dev/sgx_enclave";
 	struct encl_segment *seg;
@@ -300,7 +301,7 @@ bool encl_load(const char *path, struct encl *encl, uns=
igned long heap_size)
=20
 	encl->src_size =3D encl->segment_tbl[j].offset + encl->segment_tbl[j].siz=
e;
=20
-	for (encl->encl_size =3D 4096; encl->encl_size < encl->src_size; )
+	for (encl->encl_size =3D 4096; encl->encl_size < encl->src_size + edmm_si=
ze;)
 		encl->encl_size <<=3D 1;
=20
 	return true;
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/s=
gx/main.c
index 9820b3809c69..8d7ce9389c8f 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -25,6 +25,8 @@ static const uint64_t MAGIC =3D 0x1122334455667788ULL;
 static const uint64_t MAGIC2 =3D 0x8877665544332211ULL;
 vdso_sgx_enter_enclave_t vdso_sgx_enter_enclave;
=20
+static const unsigned long edmm_size =3D 8589934592; //8G
+
 /*
  * Security Information (SECINFO) data structure needed by a few SGX
  * instructions (eg. ENCLU[EACCEPT] and ENCLU[EMODPE]) holds meta-data
@@ -183,7 +185,7 @@ static bool setup_test_encl(unsigned long heap_size, st=
ruct encl *encl,
 	unsigned int i;
 	void *addr;
=20
-	if (!encl_load("test_encl.elf", encl, heap_size)) {
+	if (!encl_load("test_encl.elf", encl, heap_size, edmm_size)) {
 		encl_delete(encl);
 		TH_LOG("Failed to load the test enclave.");
 		return false;
@@ -1104,14 +1106,19 @@ TEST_F(enclave, augment)
  * Test for the addition of pages to an initialized enclave via a
  * pre-emptive run of EACCEPT on page to be added.
  */
-TEST_F(enclave, augment_via_eaccept)
+/*
+ * Test for the addition of pages to an initialized enclave via a
+ * pre-emptive run of EACCEPT on page to be added.
+ */
+/*TEST_F(enclave, augment_via_eaccept)*/
+TEST_F_TIMEOUT(enclave, augment_via_eaccept, 900)
 {
 	struct encl_op_get_from_addr get_addr_op;
 	struct encl_op_put_to_addr put_addr_op;
 	struct encl_op_eaccept eaccept_op;
 	size_t total_size =3D 0;
 	void *addr;
-	int i;
+	unsigned long i;
=20
 	if (!sgx2_supported())
 		SKIP(return, "SGX2 not supported");
@@ -1125,6 +1132,7 @@ TEST_F(enclave, augment_via_eaccept)
 		struct encl_segment *seg =3D &self->encl.segment_tbl[i];
=20
 		total_size +=3D seg->size;
+		TH_LOG("test enclave: total_size =3D %ld, seg->size =3D %ld", total_size=
, seg->size);
 	}
=20
 	/*
@@ -1132,7 +1140,7 @@ TEST_F(enclave, augment_via_eaccept)
 	 * test enclave since enclave size must be a power of 2 in bytes while
 	 * test_encl does not consume it all.
 	 */
-	EXPECT_LT(total_size + PAGE_SIZE, self->encl.encl_size);
+	EXPECT_LT(total_size + edmm_size, self->encl.encl_size);
=20
 	/*
 	 * mmap() a page at end of existing enclave to be used for dynamic
@@ -1142,10 +1150,10 @@ TEST_F(enclave, augment_via_eaccept)
 	 * falls into the enclave's address range but not backed
 	 * by existing enclave pages.
 	 */
-
-	addr =3D mmap((void *)self->encl.encl_base + total_size, PAGE_SIZE,
-		    PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
-		    self->encl.fd, 0);
+	TH_LOG("mmaping pages at end of enclave...");
+	addr =3D mmap((void *)self->encl.encl_base + total_size, edmm_size,
+			PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_FIXED,
+			self->encl.fd, 0);
 	EXPECT_NE(addr, MAP_FAILED);
=20
 	self->run.exception_vector =3D 0;
@@ -1156,25 +1164,29 @@ TEST_F(enclave, augment_via_eaccept)
 	 * Run EACCEPT on new page to trigger the #PF->EAUG->EACCEPT(again
 	 * without a #PF). All should be transparent to userspace.
 	 */
-	eaccept_op.epc_addr =3D self->encl.encl_base + total_size;
+	TH_LOG("Entering enclave to run EACCEPT for each page of %zd bytes may ta=
ke a while ...",
+			edmm_size);
 	eaccept_op.flags =3D SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_REG | SG=
X_SECINFO_PENDING;
 	eaccept_op.ret =3D 0;
 	eaccept_op.header.type =3D ENCL_OP_EACCEPT;
=20
-	EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
+	for (i =3D 0; i < edmm_size; i +=3D 4096) {
+		eaccept_op.epc_addr =3D (uint64_t)(addr + i);
=20
-	if (self->run.exception_vector =3D=3D 14 &&
-	    self->run.exception_error_code =3D=3D 4 &&
-	    self->run.exception_addr =3D=3D self->encl.encl_base + total_size) {
-		munmap(addr, PAGE_SIZE);
-		SKIP(return, "Kernel does not support adding pages to initialized enclav=
e");
-	}
+		EXPECT_EQ(ENCL_CALL(&eaccept_op, &self->run, true), 0);
+		if (self->run.exception_vector =3D=3D 14 &&
+			self->run.exception_error_code =3D=3D 4 &&
+			self->run.exception_addr =3D=3D self->encl.encl_base) {
+			munmap(addr, edmm_size);
+			SKIP(return, "Kernel does not support adding pages to initialized encla=
ve");
+		}
=20
-	EXPECT_EEXIT(&self->run);
-	EXPECT_EQ(self->run.exception_vector, 0);
-	EXPECT_EQ(self->run.exception_error_code, 0);
-	EXPECT_EQ(self->run.exception_addr, 0);
-	EXPECT_EQ(eaccept_op.ret, 0);
+		EXPECT_EQ(self->run.exception_vector, 0);
+		EXPECT_EQ(self->run.exception_error_code, 0);
+		EXPECT_EQ(self->run.exception_addr, 0);
+		ASSERT_EQ(eaccept_op.ret, 0);
+		ASSERT_EQ(self->run.function, EEXIT);
+	}
=20
 	/*
 	 * New page should be accessible from within enclave - attempt to
@@ -1207,7 +1219,7 @@ TEST_F(enclave, augment_via_eaccept)
 	EXPECT_EQ(self->run.exception_error_code, 0);
 	EXPECT_EQ(self->run.exception_addr, 0);
=20
-	munmap(addr, PAGE_SIZE);
+	munmap(addr, edmm_size);
 }
=20
 /*
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/s=
gx/main.h
index fc585be97e2f..fe5d39ac0e1e 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -35,7 +35,8 @@ extern unsigned char sign_key[];
 extern unsigned char sign_key_end[];
=20
 void encl_delete(struct encl *ctx);
-bool encl_load(const char *path, struct encl *encl, unsigned long heap_siz=
e);
+bool encl_load(const char *path, struct encl *encl, unsigned long heap_siz=
e,
+			   unsigned long edmm_size);
 bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
 uint64_t encl_get_entry(struct encl *encl, const char *symbol);
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selfte=
sts/sgx/sigstruct.c
index 50c5ab1aa6fa..6000cf0e4975 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -343,7 +343,7 @@ bool encl_measure(struct encl *encl)
 	if (!ctx)
 		goto err;
=20
-	if (!mrenclave_ecreate(ctx, encl->src_size))
+	if (!mrenclave_ecreate(ctx, encl->encl_size))
 		goto err;
=20
 	for (i =3D 0; i < encl->nr_segments; i++) {
--=20
2.17.1


Thanks,
-Vijay
