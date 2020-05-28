Return-Path: <SRS0=sWWJ=7K=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD2FC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987782073B
	for <linux-sgx@archiver.kernel.org>; Thu, 28 May 2020 17:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405540AbgE1ReS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 May 2020 13:34:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:39881 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405041AbgE1ReS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 May 2020 13:34:18 -0400
IronPort-SDR: by8b5X/z9FIcqT2N9bspNNyBVXqBHB6AUXTZs9d1CFqCySxHyF9f94qDlc7t3HlVftL8uDfYpF
 x2W9r8RtqZXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 10:34:17 -0700
IronPort-SDR: UK8VsZaWENO8dw73vUW4P2BD/AwGw5tUIHbPKK6Tfcx7hvKVDMdPUMzKCpdvQhT8XpHYhK/HCo
 vff4gpfP4BqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,445,1583222400"; 
   d="scan'208";a="469198982"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 28 May 2020 10:34:17 -0700
Date:   Thu, 28 May 2020 10:34:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v30 08/20] x86/sgx: Add functions to allocate and free
 EPC pages
Message-ID: <20200528173417.GC30353@linux.intel.com>
References: <20200515004410.723949-9-jarkko.sakkinen@linux.intel.com>
 <20200526125207.GE28228@zn.tnic>
 <20200527042111.GI31696@linux.intel.com>
 <20200527204638.GG1721@zn.tnic>
 <20200528012319.GA7577@linux.intel.com>
 <20200528013617.GD25962@linux.intel.com>
 <20200528065223.GB188849@linux.intel.com>
 <20200528171635.GB382@zn.tnic>
 <20200528171937.GB30353@linux.intel.com>
 <20200528172724.GC382@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528172724.GC382@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 28, 2020 at 07:27:24PM +0200, Borislav Petkov wrote:
> On Thu, May 28, 2020 at 10:19:37AM -0700, Sean Christopherson wrote:
> > On Thu, May 28, 2020 at 07:16:35PM +0200, Borislav Petkov wrote:
> > > * sgx_alloc_page - allocates an EPC page
> > 
> > Did you want this to be sgx_alloc_epc_page?
> 
> Whatever you guys prefer. I'd use "sgx_alloc_page" because it returns
> struct sgx_epc_page * but having "epc" in the name makes it even more
> explicit so either is just fine.

sgx_alloc_page() works for me, I just wanted to make sure it wasn't a typo.

Thanks!
