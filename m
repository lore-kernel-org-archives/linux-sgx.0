Return-Path: <SRS0=fW0T=7C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419B5C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 14:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAC820756
	for <linux-sgx@archiver.kernel.org>; Wed, 20 May 2020 14:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETOEN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 May 2020 10:04:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:33806 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgETOEN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 May 2020 10:04:13 -0400
IronPort-SDR: cfOqL/2PglMPsMUqmPBL46dgO7pfvm9ZT4Y5GbnsNSvyavvbOuwE23vSubNGqD6MwUMHtUTnfc
 /qmB0cd3VpRg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 07:04:12 -0700
IronPort-SDR: M9dCvdQeUC+baWWCbFtgbQpU/ZPq6nmnS5bIdWxLmZRnk9Tb+A64fwQlUFOOlp5PjS0kuQJO5Z
 IvbtydjIPTUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="440039112"
Received: from ttluu1x-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.239])
  by orsmga005.jf.intel.com with ESMTP; 20 May 2020 07:04:03 -0700
Date:   Wed, 20 May 2020 17:04:01 +0300
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
Subject: Re: [PATCH v30 02/20] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20200520140401.GB34750@linux.intel.com>
References: <20200515004410.723949-1-jarkko.sakkinen@linux.intel.com>
 <20200515004410.723949-3-jarkko.sakkinen@linux.intel.com>
 <20200520122346.GG1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520122346.GG1457@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 20, 2020 at 02:23:47PM +0200, Borislav Petkov wrote:
> 
> > Subject: Re: [PATCH v30 02/20] x86/cpufeatures: x86/msr: Intel SGX Launch Control hardware bits
> 							  ^
> 							Add
> 
> Needs a verb.

"x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits"

> On Fri, May 15, 2020 at 03:43:52AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> > Launch Control.
> > 
> > Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> > SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> > called enclaves, are always signed. All enclaves signed with the public key
> > are unconditionally allowed to initialize. [1]
> > 
> > Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
> > whether the formentioned MSRs are writable or not. If the bit is off, the
> 
> "aforementioned"
> 
> > public key MSRs are read-only for the OS.

Thanks, fixed.

> Regards/Gruss,
>     Boris.

/Jarkko
