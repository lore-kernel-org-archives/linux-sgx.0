Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3640C74A3E
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 20:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4EC321019
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 20:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGJUbF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 16:31:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:41266 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfGJUbF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 16:31:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 13:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="249579941"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 10 Jul 2019 13:31:04 -0700
Date:   Wed, 10 Jul 2019 13:31:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190710203104.GH4348@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710201930.ly7ykediuy35cjze@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710201930.ly7ykediuy35cjze@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 10, 2019 at 11:19:30PM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 09, 2019 at 10:09:17AM -0700, Sean Christopherson wrote:
> > On Tue, Jul 09, 2019 at 07:22:03PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Jul 08, 2019 at 10:29:30AM -0700, Sean Christopherson wrote:
> > > > On Fri, Jul 05, 2019 at 07:05:49PM +0300, Jarkko Sakkinen wrote:
> > > > > On Wed, Jun 19, 2019 at 03:23:49PM -0700, Sean Christopherson wrote:
> > > > > 
> > > > > I still don't get why we need this whole mess and do not simply admit
> > > > > that there are two distinct roles:
> > > > > 
> > > > > 1. Creator
> > > > > 2. User
> > > > 
> > > > Because SELinux has existing concepts of EXECMEM and EXECMOD.
> > > 
> > > What is the official documentation for those? I've only found some
> > > explanations from discussions and some RHEL sysadmin guides.
> > 
> > No clue.  My knowledge was gleaned from the code and from Stephen's
> > feedback.
> 
> OK, thanks for elaboration. Got nailed some details I was missing :-)
> 
> Anyway, to accompany your code changes I'm eager to document this not
> least because it is a good peer test that this all make sense (you
> cannot "unit test" a security model so that is the next best thing).
> 
> Still, we need a documentation reference to reflect the narrative
> for these changes, seriously. It cannot be that SELinux is widely
> deployed and it completely lacks documentation for its basic
> objects, can it?

The vast majority of documentation I've found is on *using* SELinux,
e.g. writing policies and whatnot.  I haven't found anything on its
internal details, although I admitedly haven't looked all that hard.
