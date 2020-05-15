Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7360C433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38A420709
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgEOAYI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 20:24:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:18796 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgEOAYI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 20:24:08 -0400
IronPort-SDR: +kbPdjWsVpsRdpHWWRzFGFKRfp4rVetnrUuaRxDaF9VCEZyyh8f/J51R3Xza9jicitMKIEdcWK
 vf6RLxmE6ySw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 17:24:07 -0700
IronPort-SDR: SMtXROiAJMWKlT5umti4Td4lMymBiW8pVXo45H2N1sjqJR+yahecrtmulAbIUR0+wjP6gM/s42
 MV2uru6neXLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="281039149"
Received: from ashadrin-mobl1.ccr.corp.intel.com ([10.249.38.112])
  by orsmga002.jf.intel.com with ESMTP; 14 May 2020 17:23:58 -0700
Message-ID: <fdc55706b2d7c0e547a32b958332bba96b29bee7.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com,
        David Rientjes <rientjes@google.com>, cedric.xing@intel.com,
        puiterwijk@redhat.com, Anna Sapek <asapek@google.com>,
        Conrad Parker <conradparker@google.com>,
        Keith Moyer <kmoy@google.com>,
        Yaozhang Xu <yaozhangx@google.com>,
        Chen Chen <chenalexchen@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Carmen Hanish <cyhanish@google.com>,
        Kevin Yap <ikeviny@google.com>
Date:   Fri, 15 May 2020 03:23:45 +0300
In-Reply-To: <CAJsHiNx0jnx_zwCuNecci7opgCkxg-FB8UpYvnmubjWdM3fXZQ@mail.gmail.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <20200508190813.GP27052@linux.intel.com>
         <CAJsHiNx0jnx_zwCuNecci7opgCkxg-FB8UpYvnmubjWdM3fXZQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2020-05-14 at 12:05 -0700, Seth Moore wrote:
> On Fri, May 8, 2020 at 12:08 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > Adding some Google folks to the party.
> 
> Thanks, Sean.
> 
> > On Wed, Apr 22, 2020 at 12:52:56AM +0300, Jarkko Sakkinen wrote:
> > > Intel(R) SGX is a set of CPU instructions that can be used by applications
> > > to set aside private regions of code and data. The code outside the enclave
> > > is disallowed to access the memory inside the enclave by the CPU access
> > > control.
> > > 
> > > There is a new hardware unit in the processor called Memory Encryption
> > > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> > > one or many MEE regions that can hold enclave data by configuring them with
> > > PRMRR registers.
> > > 
> > > The MEE automatically encrypts the data leaving the processor package to
> > > the MEE regions. The data is encrypted using a random key whose life-time
> > > is exactly one power cycle.
> > > 
> > > The current implementation requires that the firmware sets
> > > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> > > decide what enclaves it wants run. The implementation does not create
> > > any bottlenecks to support read-only MSRs later on.
> > > 
> > > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> > > 
> > >       cat /proc/cpuinfo  | grep sgx
> 
> We applied the v29 patches to Linux 5.6.0, then tested on Xeon(R) E-2186G
> with Asylo (http://asylo.dev).
> 
> Looks good. All Asylo tests pass.
> 
> Tested-by: Seth Moore <sethmo@google.com>

Thanks.

/Jarkko

