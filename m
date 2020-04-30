Return-Path: <SRS0=MviC=6O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A908DC83001
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 03:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0CF2073E
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 03:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD3DrG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 Apr 2020 23:47:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:31570 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3DrG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 29 Apr 2020 23:47:06 -0400
IronPort-SDR: mHnsCtM/I6+kPPJOsPpLirzb08jBUUnfp2t7nffLBle8Rs1kxiXyiJFHsagcmy5xp3Qwffjjzi
 6S8PqrqD4doA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 20:47:05 -0700
IronPort-SDR: YtzPHEi4bPpgKzUT//KwUECmqlJcspg8GyNy3mkDGSdwUMjQ7GjjSXt6S6h0rsrEYcAbuTSPzf
 g4jRmHigkYTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="276380932"
Received: from aanderso-mobl3.amr.corp.intel.com (HELO localhost) ([10.252.52.101])
  by orsmga002.jf.intel.com with ESMTP; 29 Apr 2020 20:46:52 -0700
Date:   Thu, 30 Apr 2020 06:46:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200430034651.GB31820@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 29, 2020 at 05:27:48PM +0200, Jethro Beekman wrote:
> On 2020-04-21 23:52, Jarkko Sakkinen wrote:
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
> Let's merge this.

So can I tag reviewed-by's?

/Jarkko
