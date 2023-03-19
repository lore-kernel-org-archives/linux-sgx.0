Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696BEC7618A
	for <linux-sgx@archiver.kernel.org>; Sun, 19 Mar 2023 13:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCSN0P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 19 Mar 2023 09:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCSN0O (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 19 Mar 2023 09:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321971CBD1
        for <linux-sgx@vger.kernel.org>; Sun, 19 Mar 2023 06:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B09FCB80B91
        for <linux-sgx@vger.kernel.org>; Sun, 19 Mar 2023 13:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43D6C433D2;
        Sun, 19 Mar 2023 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679232370;
        bh=QKwMEiYDKtiauMQd3Lm3GCORpgb6LdiJ5Dv4jNG6tEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0hb0FNkPAcWHlGQ0a98SKgUlZ/J+gYmp+oFE/FdWIODneGjj3lejLNKCgqju4vyX
         otURYS2uQb/CXyDhGyPi8d4/6js3BVG01zWw0qcgyWMAwX7bhIQ7dt45OILQ6amhbu
         GLSfqL3hNaoQqM2rPU0o0xaC4OJU6a/+bz2aiuaRmj3kmY4u4DchdYJUOlaPofWicu
         f1oxdAxPbgjLJ5MSplEvk4VXAOJGBOU1TC4jBVfuPMLoh8g8msbQD8J7ga488Qjz+h
         OvAtRDiHG5tVnTeK0MiyH0ob8Yo4mhUKXK88r+d2SSU9QIQwF/nAXPA3liVf/ET4T2
         x+cpZAXVLeCuw==
Date:   Sun, 19 Mar 2023 15:26:06 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <20230319132606.yatircsujyj6got5@kernel.org>
References: <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org>
 <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
 <op.11sw04rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.11sw04rxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 14, 2023 at 09:54:30AM -0500, Haitao Huang wrote:
> On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
> > > 
> > > Then in v29, PROT_NONE mapping was disallowed for encl_fd before pages
> > > EADDed so user space has to mmap anonymously to reserve the range.The
> > > intent was still not to allow mmap before pages EADDed (the !page check
> > > was still there up to v38)
> > 
> > Do you know the reason of disallowing PROT_NONE mapping against encl_fd?
> > 
> 
> I think it was to allow user space to do anonymous mapping to reserve
> address space for enclave.
> Before this point, you have to use PROT_NONE to reserve with encl_fd. There
> might be an issue with how #PF and EPC swapping was handled or the elegance
> of those flows that motivated the move but I can't remember. ABI was not
> fixed at that time so it was OK to change.

Yes, this was done because enclave naturally aligned base address.

BR, Jarkko
