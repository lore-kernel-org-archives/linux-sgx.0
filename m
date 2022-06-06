Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0AEC43334
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Jun 2022 11:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbiFFLmX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Jun 2022 07:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbiFFLmV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 6 Jun 2022 07:42:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB68F30569
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 04:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 191C5CE1A1B
        for <linux-sgx@vger.kernel.org>; Mon,  6 Jun 2022 11:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B90C34119;
        Mon,  6 Jun 2022 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654515736;
        bh=n1xvUCzuxhBB1ijxM4Ro0jg17Pk0reo2r/BJ3/3wwgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkYN+AKDPmQamOoV4eyBRoGcSRRpxaKroGPz98Jd2P+GxNYYwT1KalaxfJJ2gt+9R
         xQ/dXwKnAt6nb/5ocTceXzpWMshVM2lsoFMGT3n6DZpcYY1wB4G4OzS+M7OcK7EspM
         8CTzioiI1G9qNPTIXkSte7BqDx8botVewyJl+8tNdqvgLWI76A+z6FyiA3Y4Gt3fmb
         hRdEX8Bl8Q0J2L9LcKZhz4UPWsSxM6ReENeICVV612l2DKcoE6ZGCzQdH8AwNZDLyx
         PdtkETubKxCAJg1XoVFMSbRWWyd27Bo/zijGaiI6cUhemhaKVw30jOFQZ6wfGtN7br
         8BVJXVsRS/9zA==
Date:   Mon, 6 Jun 2022 14:40:20 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com,
        Nathaniel McCallum <nathaniel@profian.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: VMA's not getting merged
Message-ID: <Yp3npNLu6Blaphxk@iki.fi>
References: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
 <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
 <YoKb5P+VixJUn6xT@kernel.org>
 <YoRCJCtSGfxjwu2w@iki.fi>
 <Yp2q68qYtdpR+Z+T@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp2q68qYtdpR+Z+T@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 06, 2022 at 10:21:15AM +0300, Jarkko Sakkinen wrote:
> Dave: so my question is this: can VM_SPECIAL check be
> relaxed somehow, or should it be just documented that
> enclave VMAs do not get merged?

The special check feels a bit odd for me, given that

1. It's hard to imagine anything that would not be "special", and
   still would implement vma_close(). I presume that something
   like this exists. Just cannot make up anything.

2. On the other hand, is_mergeable_vma() pretty much sets the
   constraints to merge to VMA's into one. Most importantly
   it checks that vm_close() is not implemented and VMA's
   map the same file.

BR, Jarkko
