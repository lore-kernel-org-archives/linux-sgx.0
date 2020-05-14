Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE84AC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 10:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0FDB20734
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 10:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgENKuK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 06:50:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:28179 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbgENKuJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 06:50:09 -0400
IronPort-SDR: kZ3Yen+3b4qd8l7pSOm3gPb3Q3wsdhLP1/AJ/qTq4yxkWjgzIjIpQMYVpGI5xS4mFmO7b+0uCH
 wDmnVJklJQoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 03:50:08 -0700
IronPort-SDR: 6yzv9taJo2YqKErlZKB5UQZ9/+NIvrUaZXECL/VKte8rmHcm0E7VoinncrcgWeBmL30R9hB9uf
 kMCl9r4b6X4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,391,1583222400"; 
   d="scan'208";a="262798392"
Received: from apogrebi-mobl2.ger.corp.intel.com ([10.249.39.119])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2020 03:49:59 -0700
Message-ID: <f97ffc7add0fe870afc98431dd816fdcd589fe1e.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Hui, Chunyang" <sanqian.hcy@antfin.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Date:   Thu, 14 May 2020 13:49:54 +0300
In-Reply-To: <20200512115551.GA84010@sanqian-dev-0.10.0>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <20200512115551.GA84010@sanqian-dev-0.10.0>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2020-05-12 at 19:55 +0800, Hui, Chunyang wrote:
> On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
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
> Intel SGX feature. We ran Occlum tests using patch v29 on SGX hardware with
> the Flexible Launch Control (FLC) feature and didn't find any problems.
> As Occlum core developers, we would like these patches to be merged soon.

Great, thanks adding tested by to the driver and reclaimer patch.

/Jarkko

