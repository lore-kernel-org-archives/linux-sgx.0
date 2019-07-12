Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BEEC742A2
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6628621019
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 03:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfGLDQM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 23:16:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:7891 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729120AbfGLDQM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 23:16:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 20:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="168821581"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2019 20:16:06 -0700
Date:   Fri, 12 Jul 2019 06:16:05 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        luto@kernel.org, jethro@fortanix.com, greg@enjellic.com
Subject: Re: [RFC PATCH v3 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190712031605.qzlcgtbvfy6lqygt@linux.intel.com>
References: <20190424062623.4345-1-cedric.xing@intel.com>
 <cover.1562813643.git.cedric.xing@intel.com>
 <742dfe18ee4128ccccf8313b6c6cb3ee8b961712.1562813643.git.cedric.xing@intel.com>
 <20190711095317.v6tlrx2vt4tkibb3@linux.intel.com>
 <20190711154231.GA15067@linux.intel.com>
 <20190711175550.s5u46chozj5acjjr@linux.intel.com>
 <20190711175813.GM15067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711175813.GM15067@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 10:58:13AM -0700, Sean Christopherson wrote:
> > The way to do this right would be to write a documentation block before
> > kdoc's for the functions. It is described in the last section of
> > 
> > https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt0
> > 
> > I.e. organize the file as
> > 
> > 1. Documentation block describing the theory of operation.
> > 2. Functions and their associated documentations.
> 
> The kernel doc parser straight up doesn't work on asm functions, hence the
> shenanigans to coerce it into thinking it's parsing a normal C function.

Aah. I think I was too hazy with my comment. Looked it from patchwork and
the documentation is mostly just fine.

For this patch this cruft nees to be removed:

- *                           %SGX_IOC_ENCLAVE_INIT ioctl
+ *			     %SGX_IOC_ENCLAVE_INIT ioctl

These make squashing the patch properly nasty.

Also there is one unwanted rename. Did not find anything else obviously
wrong.

/Jarkko
