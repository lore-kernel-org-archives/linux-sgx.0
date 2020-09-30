Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EE5C4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 15:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921CA20738
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 15:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgI3Pnx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:43:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:9592 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI3Pnx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 11:43:53 -0400
IronPort-SDR: Kptk5HXSBXwJPdyBo0slfGNfXsCA+8W4MzL15flRSYWuxMe/t1G6y1bd6vPQwpZEGKUOJ/Gi0f
 TA5GW+mU+pHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="163334640"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="163334640"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:43:51 -0700
IronPort-SDR: w9ttUhQnm/smADSCbcdRx6C5FIOwHJyIG2EhOaPb2mguZufbLXz0GEE9egVN9o8KOmXFk7mNfn
 IEV2Ug0VoQng==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="515122027"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:43:50 -0700
Date:   Wed, 30 Sep 2020 08:43:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, Haitao Huang <haitao.huang@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
Message-ID: <20200930154349.GB32672@linux.intel.com>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930152806.GA52739@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 30, 2020 at 06:28:06PM +0300, Jarkko Sakkinen wrote:
> On Wed, Sep 30, 2020 at 07:33:38AM -0700, Dave Hansen wrote:
> > On 9/30/20 7:20 AM, Jarkko Sakkinen wrote:
> > > I'm not expert on Spectre, or any sort of security researcher, but I've
> > > read a few papers about and understand the general concept. With the
> > > constraints how the callback is used in practice, I'd *guess* it is
> > > fine to drop retpoline but I really need some feedback on this from
> > > people who understand these attacks better.
> > 
> > Do you recall why you added it in the first place?  What was the
> > motivation for it?  Were you responding to a review comment?
> 
> Absolutely cannot recall it :-) I even cannot recall the exact time when
> we landed the vDSO in the first place. Too much stuff has happend during
> the long three year upstreaming cycle. I will try to backtrack this
> info.

It originated in a comment from Andy when we were discussing the legitimacy
of the callback.  From that point on it got taken as gospel that the indirect
call would be implemented as a retpoline.

https://lkml.kernel.org/r/CALCETrVBR+2HjTqX=W4r9GOq69Xg36v4gmCKqK0wUjzAqBJnrw@mail.gmail.com
