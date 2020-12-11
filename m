Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD217C1B0D8
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AEA723F2A
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 11:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgLKL3i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 06:29:38 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:45033 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405676AbgLKL3G (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 11 Dec 2020 06:29:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 196625801B5;
        Fri, 11 Dec 2020 06:28:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Dec 2020 06:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=XXzlJO0R7OGQsbSqZv31cE04TVx
        LN2cLjnFTRh+ZYA8=; b=C0GMTx2w/YJVbvZlRyQyx0dWczVkVkQxeLuQ0I+I1go
        waWad7txB2ox3yzhGE1NGoJgrJhm40yBB/fpzNkktn9mMIr5Wl87X3HltoqZXa/D
        nMdglphkdgSx9Eltf8wp74LLcevxzAs/7ZljPRBMXvne3u6qsn4zSKmdXuZtIeEy
        Vigx+H/Oi8cpQTz5jYmFTO/ToX5x/2+lrfQk6LdXiQX5OkeC7EHUzwQ2kFEHzKEa
        ESXA2gjNtX93IJ/4+kcBF93acM0pgEwrfgGyKbEq6ldZPGTEcKRmlne66Dx6Ub/s
        DdAPVx3t814pp6Zwno1UXsyCRePGXWZ2qwMJ9Pq7PYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XXzlJO
        0R7OGQsbSqZv31cE04TVxLN2cLjnFTRh+ZYA8=; b=KBFKz+Htz0/LVU75cKlQXc
        ngeNZ/pO+8Iyopnps0pF0hbGDrwDEBoCus+cWXXEYFeyuIfptchOLru0dmLVsxIN
        4kxzgqFQYhyODFKR6qC6Tfr5eG4wR8deY75bti62TTV0rWsUX7e1HCUIHYXYOhsO
        h+Rd2VvrymDfyaIJoEhlo/MWfMEQyDZcKVnHK2NFJh8ppvd64d1RwVKXVdnAfrFb
        3rxY/dZqITbPxlUsPDifgb8PfmCJ1CyEter3cU8l2qY8y9KhLspuhBvFH/YVbadH
        1gm3fz/GMz9+hbEaJh/7xHmoJaUk4ihd/gI37DOIuZs42isMqeYH0IeoPonKTHmg
        ==
X-ME-Sender: <xms:0lfTX5Snjn83h-QoPlj1C4y4hcH2bDxY1iBJKdqYtFJqLXATxclDkQ>
    <xme:0lfTXyxuspZaga1jomi9qYzYSbUB-o-P8nXK-IBHQTtSOBpeu1k8R-lotbKvVVqOK
    qmU9_n8pKYARw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0lfTX-3I5ChsRG_w3xmufuj4K_8Qk1E0zWISgLX1_IDrvekksjkYcQ>
    <xmx:0lfTXxDnTfts-QFhAtg8iQIN_XklZqW-q85QhlUNsz2Rsw3P2INjbA>
    <xmx:0lfTXyiGxxzA8FArs7Ir84aCWk1A7GAA3kA86p1iHvUPu3o_tPIpWA>
    <xmx:1FfTX5SrNpOBYul7WXAkSKITzMQJM9lGrghiQMfKAoW_qZiu5LpgWQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CB9F1080067;
        Fri, 11 Dec 2020 06:28:18 -0500 (EST)
Date:   Fri, 11 Dec 2020 12:29:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        linux-hotplug@vger.kernel.org,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Creating executable device nodes in /dev?
Message-ID: <X9NYG1+ke6nPwBvO@kroah.com>
References: <0f17eade-5e99-be29-fd09-2d0a1949ac7f@gmail.com>
 <9DF5C88B-5156-455A-BA3F-EB19CAA0411B@amacapital.net>
 <bbdedcfd-cc24-1616-7f87-3c7f62571b22@gmail.com>
 <20201209001521.GA64007@kernel.org>
 <b1cf9503-0c1c-ab9e-3cc4-ef2b7611b280@gmail.com>
 <20201211104635.GD12091@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211104635.GD12091@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 11, 2020 at 12:46:35PM +0200, Jarkko Sakkinen wrote:
> On Wed, Dec 09, 2020 at 10:35:21AM +0200, Topi Miettinen wrote:
> > On 9.12.2020 2.15, Jarkko Sakkinen wrote:
> > > On Wed, Dec 09, 2020 at 01:15:27AM +0200, Topi Miettinen wrote:
> > > > > > > As  a further argument, I just did this on a Fedora system:
> > > > > > > $ find /dev -perm /ugo+x -a \! -type d -a \! -type l
> > > > > > > No results.  So making /dev noexec doesn't seem to have any benefit.
> > > > > > 
> > > > > > It's no surprise that there aren't any executables in /dev since
> > > > > > removing MAKEDEV ages ago. That's not the issue, which is that
> > > > > > /dev is a writable directory (for UID=0 but no capabilities are
> > > > > > needed) and thus a potential location for constructing unapproved
> > > > > > executables if it is also mounted exec (W^X).
> > > > > 
> > > > > UID 0 can just change mount options, though, unless SELinux or similar is used. And SELinux can protect /dev just fine without noexec.
> > > > 
> > > > Well, mounting would need CAP_SYS_ADMIN in addition to UID 0. Also SELinux
> > > > is not universal and the policies might not contain all users or services.
> > > > 
> > > > -Topi
> > > 
> > > What's the data that supports having noexec /dev anyway? With root
> > > access I can then just use something else like /dev/shm mount.
> > > 
> > > Has there been out in the wild real world cases that noexec mount
> > > of would have prevented?
> > > 
> > > For me this sounds a lot just something that "feels more secure"
> > > without any measurable benefit. Can you prove me wrong?
> > 
> > I don't think security works that way. An attacker has various methods to
> > choose from, some are more interesting than others. The case where rw,exec
> > /dev would be interesting would imply that easier or more common avenues
> > would be blocked, for example rw,exec /dev/shm, /tmp, /var/tmp, or
> > /run/user/$UID/ for user. Also fileless malware with pure ROP/JOP approach
> > with no need for any file system access is getting more common. It does not
> > mean that it would not be prudent to block the relatively easy approaches
> > too, including /dev.
> 
> What if we add a new mount option "chrexec", which allows exec
> for character devices (S_IFCHR).

Oh please no.
