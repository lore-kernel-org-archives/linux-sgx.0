Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E34DC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E003A233A2
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 14:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfHVO6M (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:58:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:48000 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729922AbfHVO6M (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 10:58:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 07:58:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="183912356"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2019 07:58:09 -0700
Message-ID: <3da7770443eb8cb83e186f20f8886f24ee2d80b8.camel@linux.intel.com>
Subject: Re: [PATCH v3 0/7] Fix the reported SGX selftest makefile issues
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Date:   Thu, 22 Aug 2019 17:58:08 +0300
In-Reply-To: <20190822033158.GQ29345@linux.intel.com>
References: <20190819132830.9056-1-jarkko.sakkinen@linux.intel.com>
         <20190822033158.GQ29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 20:31 -0700, Sean Christopherson wrote:
> On Mon, Aug 19, 2019 at 04:28:23PM +0300, Jarkko Sakkinen wrote:
> > Cedric Xing reported various issues in the selftest makefiles, which are
> > hopefully taken care by these patches.
> > 
> > As the last patch this patch set contains a patch that implements the
> > subdirectory traversal the for the x86 selftest directory tree. This
> > patch is meant to be a separate patch in the main SGX patch set so that
> > the bindings can be reviewed separately.
> 
> Doesn't have to be this series, but the build artifacts should be added
> to .gitignore.
> 
> Untracked files:
>   (use "git add <file>..." to include in what will be committed)
> 
>         sgx/encl.ss
>         sgx/sgxsign
>         sgx/test_sgx

Oh, good catch. Lets do it as a separate patch after I've squashed
everything.

/Jarkko

