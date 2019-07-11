Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B499C74A52
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7324E21019
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 09:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfGKJ0P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 05:26:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:50811 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfGKJ0P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 05:26:15 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 02:26:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="249728059"
Received: from spoledic-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.84])
  by orsmga001.jf.intel.com with ESMTP; 11 Jul 2019 02:26:10 -0700
Date:   Thu, 11 Jul 2019 12:26:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190711092609.jxe4uubwg5qbwfju@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
 <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 10, 2019 at 04:16:42PM -0700, Xing, Cedric wrote:
> > Still puzzling with EXECMOD given that how it is documented in
> > https://selinuxproject.org/page/ObjectClassesPerms. If anything in that
> > document is out of date, would be nice if it was updated.
> 
> If you search for "EXECMOD" in security/selinux/hooks.c in the latest
> (Linux-5.2) master, you'll find only one occurrence - at line 3702.
> 
> The logic over there, if translated into English, basically says
> FILE__EXECMOD is required (on the backing file) if mprotect() is called to
> request X on a private file mapping that has been modified by the calling
> process. That's what Sean meant by "W->X".

Looking at that part of code, there is this comment:

/*
 * We are making executable a file mapping that has
 * had some COW done. Since pages might have been
 * written, check ability to execute the possibly
 * modified content.  This typically should only
 * occur for text relocations.
 */

There is no COW done with enclaves, never. Thus, EXECMOD does not
connect in any possible way to SGX. OR, that comment is false.

Which one is it?

Also the official documentation for SELinux speaks only about COW
mappings.

Also the condition supports all this as a *private* file mapping ends up
to the anon_vma list when it gets written. We have a *shared* file
mapping

Nothing that you say makes sense to me, sorry...

/Jarkko
