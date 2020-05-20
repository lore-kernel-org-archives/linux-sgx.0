Return-Path: <SRS0=fW0T=7C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022BBC433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 14:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB6220756
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 14:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgETOA4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 May 2020 10:00:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:42179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETOAz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 May 2020 10:00:55 -0400
IronPort-SDR: qzy7/cdMpUZ8dyCUFDUz2huK80ibYlYixSSNuwN1rRqgrLVTBhA5rFgQI8Fq8CX8LTK28RflbU
 XTmEe/AJY95g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 07:00:54 -0700
IronPort-SDR: YxqroxTKwIzxY6ucUpAnsBTI86ASQQd6VG2HGha0NGmWLHK5WVOwbOqYDto+t9MKbXk4o3xVNm
 sBH+BSYuEiVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="268275311"
Received: from ttluu1x-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.239])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2020 07:00:45 -0700
Date:   Wed, 20 May 2020 17:00:44 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com, Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 01/20] x86/cpufeatures: x86/msr: Add Intel SGX
 hardware bits
Message-ID: <20200520140044.GA34750@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-2-jarkko.sakkinen@linux.intel.com>
 <20200520121604.GF1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520121604.GF1457@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 20, 2020 at 02:16:21PM +0200, Borislav Petkov wrote:
> On Fri, May 15, 2020 at 03:43:51AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add X86_FEATURE_SGX from CPUID.(EAX=7, ECX=1), which informs whether the
> > CPU has SGX.
> > 
> > Add X86_FEATURE_SGX1 and X86_FEATURE_SGX2 from CPUID.(EAX=12H, ECX=0),
> > which describe the level of SGX support available [1].
> > 
> > Remap CPUID.(EAX=12H, ECX=0) bits to the Linux fake CPUID 8 in order to
> > conserve some space. Keep the bit positions intact because KVM requires
> > this. Reserve bits 0-7 for SGX in order to maintain this invariant also
> > when new SGX specific feature bits get added.
> 
> That paragraph needs dropping now.

I dropped it (in my tree).

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
