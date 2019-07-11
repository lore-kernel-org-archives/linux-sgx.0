Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D36C73C66
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F8320872
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfGKR7n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 13:59:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:3433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbfGKR7n (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 13:59:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 10:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="364895556"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jul 2019 10:59:39 -0700
Date:   Thu, 11 Jul 2019 20:59:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v2 0/3] An alternative __vdso_sgx_enter_enclave() to
 allow enclave/host parameter passing using untrusted stack
Message-ID: <20190711175939.abpj5hgcx5kjuh22@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-1-cedric.xing@intel.com>
 <20190710111719.nnoedfo4wvbfghq7@linux.intel.com>
 <686e47d2-f45c-6828-39d1-48374925de6c@intel.com>
 <20190710224628.epjxwlpqqxdurmzo@linux.intel.com>
 <20190710231538.dkc7tyeyvns53737@linux.intel.com>
 <27cf0fc7-71c6-7dc1-f031-86bf887f1fe1@intel.com>
 <20190711093809.4ogxe25laeoyp4ve@linux.intel.com>
 <20190711155037.GB15067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711155037.GB15067@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 08:50:37AM -0700, Sean Christopherson wrote:
> On Thu, Jul 11, 2019 at 12:38:09PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Jul 10, 2019 at 04:37:41PM -0700, Xing, Cedric wrote:
> > > We are not judging which vessel is better (or the best) among all possible
> > > vessels. We are trying to enable more vessels. Every vessel has its pros and
> > > cons so there's *no* single best vessel.
> > 
> > I think reasonable metric is actually the coverage of the Intel SDK
> > based enclaves. How widely are they in the wild? If the user base is
> > large, it should be reasonable to support this just based on that.
> 
> Large enough that Andy agreed to take the vDSO code with the optional
> callback, despite his personal opinion being that mucking with uR{B,S}P
> from within the enclave is poor form.

OK, the cover letter empahasized things that did not make sense to me,
which made me to do my initial conclusions. I don't recall even reading
the word "coverage" from it.

Anyways, I'm sure we can land this after v21 has been published now that
the rationale is clear.

/Jarkko
