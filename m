Return-Path: <SRS0=O8Lc=4N=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A3AC35DF5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Feb 2020 10:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E846222C2
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Feb 2020 10:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgBYKPY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Feb 2020 05:15:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:61964 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgBYKPY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Feb 2020 05:15:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 02:15:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,483,1574150400"; 
   d="scan'208";a="226299412"
Received: from ayakove1-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.12.5])
  by orsmga007.jf.intel.com with ESMTP; 25 Feb 2020 02:15:10 -0800
Date:   Tue, 25 Feb 2020 12:15:03 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     =?utf-8?B?5LiJ5LufKOaDoOaYpemYsyk=?= <sanqian.hcy@antfin.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v24 00/24] Intel SGX foundations
Message-ID: <20200225101503.GA7350@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20200224063451.GA30331@sanqian-simulation2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200224063451.GA30331@sanqian-simulation2>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Feb 24, 2020 at 02:34:56PM +0800, 三仟(惠春阳) wrote:
> On Sat, Nov 30, 2019 at 01:13:02AM +0200, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > to set aside private regions of code and data. The code outside the enclave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.
> > 
> > There is a new hardware unit in the processor called Memory Encryption
> > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> > one or many MEE regions that can hold enclave data by configuring them with
> > PRMRR registers.
> > 
> > The MEE automatically encrypts the data leaving the processor package to
> > the MEE regions. The data is encrypted using a random key whose life-time
> > is exactly one power cycle.
> > 
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> > 
> > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> > 
> > 	cat /proc/cpuinfo  | grep sgx
> 
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> 
> Occlum project (https://github.com/occlum/occlum) is a libOS built on top of
> Intel SGX feature. We ran Occlum tests using patch v24 on SGX hardware with
> the Flexible Launch Control (FLC) feature and didn't find any problems.
> As Occlum core developers, we would like these patches to be merged soon.

Thank you.

I updated the commit:

https://github.com/jsakkine-intel/linux-sgx/commit/3475daeca0793d9ef69204d4981af3cacd888409

/Jarkko
