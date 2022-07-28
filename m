Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113D2C04A68
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Jul 2022 07:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiG1Hw4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Jul 2022 03:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiG1Hwz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Jul 2022 03:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CF761B14;
        Thu, 28 Jul 2022 00:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005EAB82284;
        Thu, 28 Jul 2022 07:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6D3C433D7;
        Thu, 28 Jul 2022 07:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658994772;
        bh=awT9E7pmXQPHaCuOZtxH8QBh5NKinHSK07qCS2oIN6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GoEX/4ujoP/q4QKrKR6AbLBllUD7AvnVDd9JqHpO4fIB8hikX0YIjI2Zyni39Tbsd
         CeCRul1KfyD9jdj9fAn4RHnUnnQmnqn2OgjXwxPgFE6w3csAlJ26o6g912kukQPkgR
         41CTzTJvQrxajPwq+wuo8uO/miLKwkrOktgPbUi9bQGoKRzO9lh4Mt84bTcB9fj3/R
         8xFcYjf/XBkG9njQgyBXm9J3o6ziw/gbJ8k9kuU73Ur4uHjdxOZmDc5XNcos2twI7b
         leuVy1OX/QFkH5rktdJ6kQNIXVNguhNvwo/3fahrdsCW8gIj4yvJROEdHZ2R/L4Xml
         g5WbNPXfKgCVw==
Date:   Thu, 28 Jul 2022 10:52:49 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Allow enclaves to use Asynchrounous Exit
 Notification
Message-ID: <YuJAUQomVxGZHJFq@kernel.org>
References: <20220705183648.3739111-1-dave.hansen@linux.intel.com>
 <op.1pasmtstwjvjmi@hhuan26-mobl1.mshome.net>
 <197bba3c-acd2-eb13-4f27-7a5e914ed2e4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <197bba3c-acd2-eb13-4f27-7a5e914ed2e4@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 19, 2022 at 10:54:41AM -0700, Dave Hansen wrote:
> Oh, and, btw...  I don't have any hardware that can actually test this
> patch.  It can't be applied until I have an actual tested-by from
> someone with the hardware.

... I bet that NUC7's will never get a patch

BR, Jarkko
