Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCF6C4742C
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 10:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97C5F2068D
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 10:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgKPKKD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Nov 2020 05:10:03 -0500
Received: from outbound-smtp13.blacknight.com ([46.22.139.230]:48211 "EHLO
        outbound-smtp13.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728663AbgKPKKD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 Nov 2020 05:10:03 -0500
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp13.blacknight.com (Postfix) with ESMTPS id 744F81C432F
        for <linux-sgx@vger.kernel.org>; Mon, 16 Nov 2020 10:10:01 +0000 (GMT)
Received: (qmail 19025 invoked from network); 16 Nov 2020 10:10:01 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 16 Nov 2020 10:10:00 -0000
Date:   Mon, 16 Nov 2020 10:09:57 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        haitao.huang@intel.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v41 10/24] mm: Add 'mprotect' hook to struct
 vm_operations_struct
Message-ID: <20201116100957.GM3371@techsingularity.net>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201112220135.165028-11-jarkko@kernel.org>
 <20201115173208.GR17076@casper.infradead.org>
 <96318679-3320-8d7c-d178-7fa34ed11fdf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <96318679-3320-8d7c-d178-7fa34ed11fdf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 15, 2020 at 10:36:51AM -0800, Dave Hansen wrote:
> On 11/15/20 9:32 AM, Matthew Wilcox wrote:
> > On Fri, Nov 13, 2020 at 12:01:21AM +0200, Jarkko Sakkinen wrote:
> >> +++ b/include/linux/mm.h
> >> @@ -559,6 +559,13 @@ struct vm_operations_struct {
> >>  	void (*close)(struct vm_area_struct * area);
> >>  	int (*split)(struct vm_area_struct * area, unsigned long addr);
> >>  	int (*mremap)(struct vm_area_struct * area);
> >> +	/*
> >> +	 * Called by mprotect() to make driver-specific permission
> >> +	 * checks before mprotect() is finalised.   The VMA must not
> >> +	 * be modified.  Returns 0 if eprotect() can proceed.
> >> +	 */
> > 
> > This is the wrong place for this documentation, and it's absurdly
> > specific to your implementation.  It should be in
> > Documentation/filesystems/locking.rst.
> 
> I'll let you and Mel duke that one out:
> 

I suggested placing the comment there to make it clear what the expected
semantics of the hook was to reduce the chances of abuse or surprises. The
hook does not affect locking so Documentation/filesystems/locking.rst
didn't appear appropriate other than maybe adding a note there
that it doesn't affect locks. The hook also is not expecting any
filesystems-specific action that I aware of but a note could be added to
the effect that filesystems should not need to take special action for it.
Protections on the filesystem level are for the inode, I can't imagine what
a filesystem would do with a protection change on the page table level
but maybe I'm not particularly imaginative today.

-- 
Mel Gorman
SUSE Labs
