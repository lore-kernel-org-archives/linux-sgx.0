Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40784C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Apr 2022 07:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiDFHGZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Apr 2022 03:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351839AbiDFGcS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 Apr 2022 02:32:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8693D2D4BCF
        for <linux-sgx@vger.kernel.org>; Tue,  5 Apr 2022 21:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649218924; x=1680754924;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DL6MqTralNIu1EZcoVNGKcVto1B893TqzzkUYaIYVCM=;
  b=ndgS64vCZw2d9WZdkl1E0ihTumaBZnasAC8AgtyIB2vOc1GOC3MmQBx3
   RzCTSQoBxHGE1qnesYl5e/6g4Cr3vW1BhsRwMCp2VmkpHOC2zEP4qULKu
   XPzAP4PSPwOE0nTvGEb7VGNOt040gurOcOAILsR1JX+r9IYx1LAAWfFrk
   3hDGLf000Zx4wEVa+s4kj4M9c/B89yxfFpuwOA+lOvuGcvkIgdWtAVyqz
   1fP9/zbTbrhkpDC6lZlUEQM6av2VL9DjvvqrP6YVv2bh4ZIETmlJ425be
   Q5VNHG2kK+K3tK0FBrYUb8xJT0ShokgXxzFoMjp6ajI1E6EPW4wLK0u2Q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="347390078"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="347390078"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524297086"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 05 Apr 2022 21:21:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 21:21:57 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 5 Apr 2022 21:21:56 -0700
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84]) by
 fmsmsx604.amr.corp.intel.com ([10.18.126.84]) with mapi id 15.01.2308.027;
 Tue, 5 Apr 2022 21:21:56 -0700
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: RE: [RFC PATCH v3 06/10] x86/sgx: Forced EPC page zapping for
 EUPDATESVN
Thread-Topic: [RFC PATCH v3 06/10] x86/sgx: Forced EPC page zapping for
 EUPDATESVN
Thread-Index: AQHYRdQ1s4/fRvssFEa33wJdfhWmCKzecp8AgAPbN/A=
Date:   Wed, 6 Apr 2022 04:21:56 +0000
Message-ID: <4c9eb8264f4b4d77a8ede5e17a0e0d0c@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-7-cathy.zhang@intel.com> <Ykl0+Da6t7z9VSuA@kernel.org>
In-Reply-To: <Ykl0+Da6t7z9VSuA@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> -----Original Message-----
> From: Jarkko Sakkinen <jarkko@kernel.org>
> Sent: Sunday, April 3, 2022 6:21 PM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: linux-sgx@vger.kernel.org; x86@kernel.org; Chatre, Reinette
> <reinette.chatre@intel.com>; Hansen, Dave <dave.hansen@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>
> Subject: Re: [RFC PATCH v3 06/10] x86/sgx: Forced EPC page zapping for
> EUPDATESVN
>=20
> On Fri, Apr 01, 2022 at 10:24:05PM +0800, Cathy Zhang wrote:
> > Before an EUPDATESVN instruction can be successful, all enclave pages
> > (EPC) must be marked as unused in the SGX hardware metadata (EPCM).
> >
> > A page becomes unused when an issued EREMOVE instruction succeeds.
> > To prepare for EUPDATESVN, loop over all SGX pages and attempt to
> > EREMOVE them. This is fatal to running enclaves and destroys all
> > enclave state and memory contents. This destruction is by design and
> > mitigates any compromise of enclaves or the SGX hardware itself which
> > occurred before the microcode update.
> >
> > An EREMOVE operation on a page may fail for a few reasons. Each has
> > its own mitigations.
> >
> > First, EREMOVE will fail if an enclave that uses the page is
> > executing. Send an IPI to all CPUs that might be running the enclave
> > to force it out of the enclave long enough to EREMOVE the page. Other
> > CPUs might enter the enclave in the meantime, so this is not a
> > rock-solid guarantee.
> >
> > Second, EREMOVE can fail on special SGX metadata pages, such as SECS
> > and VA. EREMOVE will work on them only after the normal SGX
>=20
> Ignoring concurrency rules that apply to any type of EPC page, VA page ca=
n
> be removed at any point of time, i.e. the first sentence in this paragrap=
h is
> not factually true.

Yes, the SGX metadata pages failed to be EREMOVEd and be tracked for a late=
r
retry is SECS pages.

Removed "VA" from the sentence Jarkko mentioned, Thanks for pointing out!

>=20
> BR, Jarkko
