Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670B1C4338F
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 23:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51145610CB
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 23:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhHSXoZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 19:44:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:7152 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233711AbhHSXoZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Aug 2021 19:44:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="216710972"
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="216710972"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 16:43:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="522651893"
Received: from srnarvek-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.23.30])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 16:43:43 -0700
Date:   Fri, 20 Aug 2021 11:43:41 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Saravanan D <saravanand@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Message-Id: <20210820114341.4b9d1aea68bffd7dedd13ef8@intel.com>
In-Reply-To: <9ec30322d0d133bfa695da475d4de736994a6c68.camel@kernel.org>
References: <20210819124824.52169-1-jarkko@kernel.org>
        <20210819124824.52169-2-jarkko@kernel.org>
        <9ec30322d0d133bfa695da475d4de736994a6c68.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 19 Aug 2021 15:52:48 +0300 Jarkko Sakkinen wrote:
> On Thu, 2021-08-19 at 15:48 +0300, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on desktops
> > or VM's, up to many GB's on servers.  Just like for regular memory, it is
> > sometimes useful to know the amount of usable SGX memory in the system.
> > 
> > Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
> > usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> > BIOS, the printout would be:
> > 
> > SGX_MemTotal:      22528 kB
> > 
> > It is less than 32 MB because some of the space is reserved for Enclave
> > Page Cache Metadata (EPCM), which contains state variables for all the
> > pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> > which applications can use to create enclaves.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> While working on this, I noticed that suddenly my i5-9660k desktop fully
> supports SGX on Linux. I don't recall that it has worked in the patch.
> Maybe this is because of some firmware/ucode update, do not really know,
> but definitely not a bad thing.
> 
> Perhaps this casts through other 9th gen Core CPU's.
> 
> The motherboard I have in this machine is AORUS Elite z390.
> 
> /Jarkko
> 

Enabling SGX also requires BIOS support, so perhaps it's BIOS update that makes
SGX available.

Btw, with SGX KVM, EPC will be discovered regardless FLC is available
or not. You need to check whether /dev/sgx_enclave is present or not to truly
know whether SGX driver is usable.
