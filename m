Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44D9C433F5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jan 2022 18:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242906AbiAFS1E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Jan 2022 13:27:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:57225 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243120AbiAFS0b (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Jan 2022 13:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493591; x=1673029591;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fx7+c2Epwwh2Sbl72Cm4SkSbtq9j+6vEKgO5AXvuhr4=;
  b=oCZffd9JCQ8Hd33WPt9JdX14sQ4/q5vHjGvKfH8BSoz2HaCHMEnHCmXm
   ohsjhSYS1KZ9eQxcW4R2jyQdSvfJoV4xmc3BleDS8DkG0bsFIidO33WFc
   eSvQWZx4QtQp8dRxpvLuGZ4eBMk++s65fOJOVVDpfzNajUbY1UU3FHaPx
   ONFeCzIWdaGdv8F+An3NicRItS7EgNijVuw1ANlZB9AddfcElpShxIfBC
   o1peTG6z7O5hVCOpjT3hV/lb1b4h2dDVQv1e2Txt8Vspb7aGXL/YSmLhh
   BwOkaUOuk/BnbivqXTWUAHJAy0f79JxFUHUt+vhzbYNV6PoRdXHAev5dV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="241527811"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="241527811"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:26:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="689504111"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.56.236])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:26:29 -0800
Message-ID: <8aa0be2752ed26317ff9b24c9803ccef542ce6ab.camel@linux.intel.com>
Subject: Re: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date:   Thu, 06 Jan 2022 10:26:18 -0800
In-Reply-To: <YcuX/DzVsAWvhEBA@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
         <20211220174640.7542-2-kristen@linux.intel.com> <YcuX/DzVsAWvhEBA@iki.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko, thanks for your review,

On Wed, 2021-12-29 at 01:04 +0200, Jarkko Sakkinen wrote:
> On Mon, Dec 20, 2021 at 09:46:39AM -0800, Kristen Carlson Accardi
> wrote:
> > 
> > +
> > +/**
> > + * sgx_charge_mem() - charge for a page used for backing storage
> > + *
> 
> Please remove this empty line:
> 
> https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

I read this to be that there should be an empty line after the short
description/arg list but before the longer description. I think for
functions without args this is the proper layout. It also is more
readable.

> 
> > + * Backing storage usage is capped by the
> > sgx_nr_available_backing_pages.
> > + * If the backing storage usage is over the overcommit limit,
> 
> Where does this verb "charge" come from?

Charge in this context means that some available backing pages are now
not available because they are in use. It feels appropriate to me to
use "charge/uncharge" verbs for this action, unless you think it's
confusing somehow.


