Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7A6C71142
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46AC021019
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfGKRv5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 13:51:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:32094 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbfGKRv5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 13:51:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 10:51:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="189581239"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jul 2019 10:51:52 -0700
Date:   Thu, 11 Jul 2019 20:51:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190711175151.xwxdfbvxbm6esymk@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
 <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
 <20190711092609.jxe4uubwg5qbwfju@linux.intel.com>
 <ef0c9052-d22e-aaa6-4915-b1823abea64c@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef0c9052-d22e-aaa6-4915-b1823abea64c@tycho.nsa.gov>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 10:32:41AM -0400, Stephen Smalley wrote:
> The existing permissions don't map cleanly to SGX but I think Sean and
> Cedric were trying to make a best-effort approximation to the underlying
> concepts in a manner that permits control over the introduction of
> executable content.
> 
> Sure, the existing EXECMOD check is only applied today when there is an
> attempt to make executable a previously modified (detected based on COW
> having occurred) private file mapping.  But the general notion of
> controlling the ability to execute modified content is still meaningful.

OK to summarize EXECMOD does not connect with SGX in any possible way
but SGX needs something that mimics EXECMOD behaviour?

And the same probably goes for EXECMEM, which is also private mapping
related concept.

> In the case of regular files, having both FILE__WRITE and FILE__EXECUTE to
> the file is sufficient because that implies the ability to execute modified
> content.  And those FILE__* checks predated the introduction of EXECMOD and
> EXECMEM.

Right.

> The mapping of /dev/sgx/enclave doesn't really fit existing categories
> because it doesn't provide the same semantics as a shared mapping of a
> regular file.  Userspace will always need both FILE__WRITE and FILE__EXECUTE
> to /dev/sgx/enclave.

Right.

Yeah, that has been the confusing part for me that they've been shuffled
in the discussion together with SGX concepts and hooks like there was
any connection. Thank you for clarifying this!

/Jarkko
